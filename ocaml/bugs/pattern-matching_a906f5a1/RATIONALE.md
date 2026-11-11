# Rationale
All changes are in ocaml/lambda/matching.ml, reversing fix.diff hunks:
- `@@ -3955,92 +3955,6 @@ ... compile_no_test`: re-added `is_lazy_pat`, `has_lazy`, `is_record_with_mutable_field`, `has_mutable`, `check_partial`, `check_partial_list` (using `lbl.lbl_mut` as `Types.lbl_mut` no longer resolves in today's code).
- `@@ -4087,7 +4001,15 @@ toplevel_handler`: removed the `only_refutations` logic, restoring `if !Clflags.safer_matching then Partial else partial`.
- `@@ -4107,7 +4029,6 @@ compile_matching`: re-added `let partial = check_partial pat_act_list partial in`.
- `@@ -4311,7 +4232,6 @@ for_tupled_function`: re-added `check_partial_list` call.
- `@@ -4399,7 +4319,6 @@ do_for_multiple_match`: re-added `check_partial` call.
(Changes entry and test hunks not touched.)

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> check_partial.ml failed (expected output differs: matches degraded to Partial). Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: failed.
