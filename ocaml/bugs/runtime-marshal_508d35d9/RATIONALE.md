# Rationale

## Bug re-introduced

File: `ocaml/runtime/intern.c`, function `intern_record_obj`.

The upstream fix (commit 508d35d970a70a39ea2c9d9241ae4587a9b3a96a,
"robustify intern.c") added a bounds check inside `intern_record_obj` that
makes sure the number of objects recorded into `s->intern_obj_table` during
unmarshaling never exceeds `s->intern_num_objects`, the number of objects
announced in the external-value header. Without that check, a corrupted or
maliciously crafted marshaled value whose header under-reports the number of
shared objects (while the body of the value actually contains more object
nodes needing sharing, e.g. via `Shared` or `Block/Object` codes) causes
`intern_record_obj` to write past the end of the `intern_obj_table`
allocation (which is sized exactly `intern_num_objects * sizeof(value)`),
producing a heap buffer overflow instead of a clean `Failure
"input_value: too many objects"` exception.

I removed exactly that guard, restoring the pre-fix (vulnerable) behavior:

```c
Caml_inline void intern_record_obj(struct caml_intern_state* s, value v)
{
  if (s->intern_obj_table != NULL) {
    s->intern_obj_table[s->obj_counter++] = v;
  }
}
```

(the `if (CAMLunlikely(s->obj_counter >= s->intern_num_objects)) {
intern_cleanup_failwith(s, "input_value: too many objects"); }` block was
deleted).

This reverses the following hunk of `fix.diff` (file
`runtime/intern.c`, hunk header `@@ -141,19 +152,44 @@ void
caml_free_intern_state (void)`), specifically this part of the added code:

```
+Caml_inline void intern_record_obj(struct caml_intern_state* s, value v)
+{
+  if (s->intern_obj_table != NULL) {
+    if (CAMLunlikely(s->obj_counter >= s->intern_num_objects)) {
+      intern_cleanup_failwith(s, "input_value: too many objects");
+    }
+    s->intern_obj_table[s->obj_counter++] = v;
+  }
+}
```

All other pieces of the fix (the `intern_check_read` bounds-checked readers,
`intern_src_end`, `intern_dest_end`, the bigarray deserialization overflow
check, `MAX_INTEXT_HEADER_SIZE` widening, etc.) were left untouched, since
they are not required to reproduce the bug and touching them would risk
introducing unrelated breakage. The single missing bounds check in
`intern_record_obj` is sufficient on its own to let a corrupted stream with
too many shared/sized objects overflow `intern_obj_table`, which is exactly
what the new fuzzing test `testsuite/tests/lib-marshal/fuzzy.ml` (added by
the same fix) exercises by flipping random bytes of marshaled data and
re-unmarshaling it, expecting only a clean `Failure`/`Invalid_argument` or
success — not a crash.

## Build and test commands run

```
cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd ..
sh run-oracle.sh
```

Final run output (relevant lines):

```
... testing 'fuzzy.ml' with default (native) => failed (Running program .../fuzzy.opt with arguments -n 10000: command ...)
... testing 'fuzzy.ml' with default (bytecode) => passed
```

The native run of `tests/lib-marshal/fuzzy.ml` (from ORACLE.txt) now fails
(crashes) due to the reintroduced heap buffer overflow in
`intern_record_obj`, confirming the bug was successfully re-introduced. All
other oracle actions pass as before.

RESULT: injected
