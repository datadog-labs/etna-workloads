# Adapted injection for Fix ICE in pattern matching with generic const array length errors

Fix: https://github.com/rust-lang/rust/commit/4a886add5c472aaa8d68c572b32566b57ee51315

# Rationale: re-injecting rust-lang/rust#139815 (fix 4a886add, PR #147724)

## Hunk: compiler/rustc_mir_build/src/builder/matches/match_pair.rs, `InterPat::lower_thir_pat`, `PatKind::Array` arm

Fix hunk re-expressed:
```
@@ -43,13 +43,23 @@ impl<'a, 'tcx> Builder<'a, 'tcx> {
         let (min_length, exact_size) = if let Some(place_resolved) = place.try_to_place(self) {
-            match place_resolved.ty(&self.local_decls, tcx).ty.kind() {
-                ty::Array(_, length) => (
-                    length
-                        .try_to_target_usize(tcx)
-                        .expect("expected len of array pat to be definite"),
-                    true,
-                ),
+            let place_ty = place_resolved.ty(&self.local_decls, tcx).ty;
+            match place_ty.kind() {
+                ty::Array(_, length) => {
+                    if let Some(length) = length.try_to_target_usize(tcx) {
+                        (length, true)
+                    } else {
+                        tcx.dcx().span_delayed_bug(...
+                            "array length in pattern couldn't be evaluated", ...);
+                        ((prefix.len() + suffix.len()).try_into().unwrap(), false)
```

In 1.99.1 the array/slice projection code was refactored: the length is now
computed in `lower_thir_pat` and passed as `array_len: Option<u64>` to
`prefix_slice_suffix`. The code there reads the length from `pattern.ty` and, if
it can't be evaluated, emits a `span_delayed_bug` and skips the subpatterns. That
is the fixed behaviour.

My change brings back the parent commit's logic. When the place resolves
(`place_builder.try_to_place(cx)`), the array length comes from the place's type
in `local_decls` (`place_resolved.ty(&cx.local_decls, cx.tcx)`) and is unwrapped
with `.expect("expected len of array pat to be definite")`. The
delayed-bug/skip-subpatterns fallback is removed. Subpatterns are always lowered
through `prefix_slice_suffix(&place_builder, array_len, ...)`.

Using the place type matters. Typeck normalizes `pattern.ty` to `[u32; 5]`, so
re-adding only the `.expect` on `pattern.ty` did not reproduce the bug (I tried
that first; the test still passed). The parameter's type in `local_decls` keeps
the un-evaluable const `{ N + 1; 5 }`, which is exactly the state the parent
commit panicked on.

When the place can't be resolved (the parent's `else` branch), I keep the
`pattern.ty`-based length rather than the parent's "treat as slice" fallback.
1.99.1's lowering assumes `Some(len)` for arrays, so switching that branch would
change unrelated behaviour. It is also not needed to reproduce the bug.
