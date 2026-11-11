# Adapted injection for Re-do recursive const stability checks

Fix: https://github.com/rust-lang/rust/commit/a0215d8e46aab41219dea0bb1cbaaf97dafe2f89

# Rationale
1. compiler/rustc_const_eval/src/check_consts/mod.rs, `is_fn_or_trait_safe_to_expose_on_stable`, `None =>` arm:
   was `def_id.is_local() && tcx.features().staged_api()`, now `false`. Re-expresses the fix hunk
   `@@ -90,50 +92,38 @@ ... pub fn is_safe_to_expose_on_stable_const_fn` where the new code trusts unmarked
   local functions (parent: `None => false, // By default, items are not const stable.`), so unmarked
   `const fn`s were never const-callable / safe to expose from stable const fns.
2. compiler/rustc_const_eval/src/check_consts/check.rs, call-check of unstable-const callee: removed
   `&& callee_safe_to_expose_on_stable` from the `allows_unstable` early return. Re-expresses the fix hunk
   `@@ -681,66 +740,68 @@` ("We only honor `span.allows_unstable` aka `#[allow_internal_unstable]` only if the
   callee is safe to expose"); the parent returned on `allows_unstable` unconditionally.
