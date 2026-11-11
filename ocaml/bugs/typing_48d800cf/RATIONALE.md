# Re-introducing #8575 (polymorphic variants vs. constructor disambiguation)

## Hunk changed

**File:** `ocaml/typing/typecore.ml`, in `type_expect_`, case `Pexp_variant(l, sarg)`
(roughly line 4565).

**Fix hunk it reverses:** `@@ -3008,7 +3008,7 @@ and type_expect_`, where the fix changed
`let row = row_repr row in` into `let row = row_repr row and row0 = row_repr row0 in`.
Before the fix, the tag `l` was looked up with `List.assoc l row0.row_fields` on the raw,
un-normalised `row0`. That only sees the fields stored directly in the first link of the
row, and misses any fields that sit in `Tvariant` rows linked through `row_more`.

**What the change does:** in today's code `row_desc` is abstract, and `row_repr` was
replaced by accessors like `get_row_field`, which always follow the `row_more` chain. So
the fix is now done implicitly by `get_row_field l row0`. To bring the pre-fix behaviour
back, I replaced that call for `row0` only with a lookup in the immediate `row_fields` of
`row0`, without following the chain. `row_fields` is the first field of the record, so
the code reads it through `Obj.magic`, because typecore cannot reach the abstract record
any other way. A missing tag gives `rf_absent`, which is the equivalent of the old
`Not_found`. The match then drops to the generic path, where the argument is typed with
no expected type. The lookup on `row` is unchanged; before the fix, `row` was already
normalised.

Effect: in pr8575.ml, `` `A_t B `` in the third phrase no longer gets the expected type
`A.t` for its argument. The compiler reports "Unbound constructor B" even in
non-principal mode, where the expected output is a successful typing (with a principal
warning in -principal mode).

## Commands and results
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`:
  build OK; `tests/typing-polyvariants-bugs/pr8575.ml => failed` (the third phrase now
  gives `Error: Unbound constructor "B"`).
- Final: `make clean && make -j8 && make -j8 ocamltest`: build OK (exit 0);
  `sh run-oracle.sh`: `pr8575.ml => failed`.

RESULT: injected
