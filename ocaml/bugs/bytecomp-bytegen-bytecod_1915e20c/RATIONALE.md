# Rationale

## Change made

File: `ocaml/bytecomp/bytegen.ml`, function `comp_block` (around line 1043-1050).

Before (today's fixed code):

```ocaml
let comp_block env exp sz cont =
  let stack_info = create_stack_info () in
  let code = comp_expr stack_info env exp sz cont in
  let used_safe = !(stack_info.max_stack_used) + Config.stack_safety_margin in
  if used_safe > Config.stack_threshold then
    Kconst(Const_int used_safe) ::
    Kccall("caml_ensure_stack_capacity", 1) ::
    code
  else
    code
```

After (bug re-introduced):

```ocaml
let comp_block env exp sz cont =
  let stack_info = create_stack_info () in
  let code = comp_expr stack_info env exp sz cont in
  let used_safe = !(stack_info.max_stack_used) + (-16) in
  if used_safe > Config.stack_threshold then
    Kconst(Const_int used_safe) ::
    Kccall("caml_ensure_stack_capacity", 1) ::
    code
  else
    code
```

This reverts the core of the upstream fix hunk:

```
@@ -906,9 +906,9 @@ and comp_binary_test env cond ifso ifnot sz cont =
 let comp_block env exp sz cont =
   max_stack_used := 0;
   let code = comp_expr env exp sz cont in
-  (* +1 because comp_expr may have pushed one more word *)
-  if !max_stack_used + 1 > Config.stack_threshold then
-    Kconst(Const_base(Const_int(!max_stack_used + 1))) ::
+  let used_safe = !max_stack_used + Config.stack_safety_margin in
+  if used_safe > Config.stack_threshold then
+    Kconst(Const_base(Const_int used_safe)) ::
     Kccall("caml_ensure_stack_capacity", 1) ::
     code
   else
```

The upstream fix introduced `Config.stack_safety_margin` as a deliberate extra
safety margin (beyond the bare "+1 because comp_expr may push one more word")
reserved at the bottom of the bytecode interpreter stack, to account for
intermediate computations performed by some bytecode instructions and by the
event/signal handler, which can use stack space beyond what `max_stack_used`
tracks. Without this margin, the computed "stack used" estimate fed into
`caml_ensure_stack_capacity` can be smaller than what is actually needed,
so the stack is not grown enough, and the bytecode interpreter can write past
the bottom of its allocated stack (observed here as a `Stack_base <= sp`
assertion failure / SIGILL abort, i.e. a crash instead of a clean
`Stack_overflow` exception) — this is exactly PR#7168.

In the current source tree, `Config.stack_safety_margin` is defined as `6`
(see `utils/config.common.ml.in`), which, combined with how stack usage is
now computed/rounded elsewhere in the current (multicore-ready, fiber-stack
based) runtime, happened to still leave enough slack for `pr7168.ml` to pass
even when the margin was reduced to the old bare `+1`. To reliably reproduce
a failure of the oracle test with this codebase, the safety margin additive
term had to be made more clearly insufficient (down to `-16`, i.e. actually
*reducing* the apparent stack usage instead of padding it), which plays the
same functional role as dropping/weakening the fix: the reserved stack
capacity requested from `caml_ensure_stack_capacity` is deliberately
under-estimated, so the deeply recursive bytecode-compiled program in
`testsuite/tests/misc/pr7168.ml` overruns the interpreter stack instead of
cleanly raising `Stack_overflow`.

Only this one hunk was changed, in the one file (`bytecomp/bytegen.ml`) that
the upstream fix touched for the actual bug (the `Changes`,
`utils/config.mli`, `utils/config.mlp`, and test-file hunks of fix.diff are
documentation/test additions / interface declarations, not behavioral code
to invert; `stack_safety_margin` itself is still present/declared in
`utils/config.*` as introduced by the fix — only its use at the one call site
in `bytegen.ml` was neutralized).

## Build and test commands run

```
cd ocaml && make clean && make -j8 && make -j8 ocamltest
cd .. && sh run-oracle.sh
```

Final results:
- `make clean && make -j8 && make -j8 ocamltest` completed successfully (exit 0).
- `sh run-oracle.sh` exits with code 1 (failure). Output shows:
  - `pr7168.ml` with line 5 (bytecode) => failed, with the bytecode binary
    crashing (`Process ... got signal 4 (Illegal instruction)`,
    `Assertion failed: Stack_base(domain_state->current_stack) <= sp`,
    exit code -4) instead of printing `OK` as expected by
    `tests/misc/pr7168.reference`.
  - The `native` and `no-tsan` sub-variants still pass, as expected (native
    code is not affected by this bytecode-stack-sizing bug, and PR#7168's own
    test explicitly skips native code for the stack-overflow-detection
    aspect).

This confirms at least one test in ORACLE.txt (`tests/misc/pr7168.ml`) now
fails, reproducing the crash that PR#7168 / the fix commit addressed.

RESULT: injected
