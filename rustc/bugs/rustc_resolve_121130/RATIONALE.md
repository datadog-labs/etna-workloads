# Adapted injection for Suggest moving if non-found macro_rules! is defined later

Fix: https://github.com/rust-lang/rust/commit/97feb71254a4f6e01d355941e18cd9e9b33b9fa4

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, the macro-not-found suggestion function (where `unused_macro` is looked up).
Removed the `if Some(parent_nearest.to_def_id()) == scope.opt_def_id() { MacroDefinedLater; MacroSuggMovePosition; return; }` branch.
This re-expresses fix hunk `@@ -1456,6 +1459,24 @@ impl<'a, 'tcx> Resolver` in diagnostics.rs, which added the `unused_macro` lookup with
`err.subdiagnostic(MacroDefinedLater{..}); err.subdiagnostic(MacroSuggMovePosition{..}); return;`.
Without it, the "defined later / consider moving" note and label are not emitted.
The errors.rs and messages.ftl hunks (new subdiagnostic structs and messages) were left in place, because the types are still used elsewhere or just unused.
