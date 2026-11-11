# Adapted injection for Special-case alias ty in `try_from_lit`

Fix: https://github.com/rust-lang/rust/commit/cd2b0309cc948a54a7bdbc3050b0d7d6b0826f93

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `try_lower_anon_const_lit`.
In 1.99.1 the old `Const::try_from_lit` (compiler/rustc_middle/src/ty/consts.rs) no longer exists; its logic moved here.
Fix hunk `@@ -305,6 +305,10 @@ impl<'tcx> Const<'tcx>`: added
`Err(_) if lit_input.ty.has_aliases() => { /* allow the ty to be an alias type */ return None; }` before the delayed-bug arm.
Re-expression: a literal whose expected type has aliases is again sent to `lit_to_const` (`|| ty.has_aliases()`), and failure
(None) emits `span_delayed_bug` as the pre-fix `Err(e)` arm did, instead of quietly returning None. Result: delayed-bug ICE on `foo::<12>()` with `<i32 as Identity>::Identity`.
