# Adapted injection for Replace closures with `_` when suggesting fully qualified path for method call

Fix: https://github.com/rust-lang/rust/commit/5fae66592494d37aa9b7c3add8c0e6077e0833f7

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/need_type_info.rs (moved from rustc_infer), fn that builds SourceKindSubdiag (InferSourceKind arms).
- FullyQualifiedMethodCall arm: removed `args.make_suggestable(tcx, true, placeholder)?` so raw args (closures, fn defs) are printed. Re-expresses hunk `@@ -546,40 +546,55 @@` in need_type_info.rs, which added `args.make_suggestable(self.infcx.tcx, true, placeholder)`.
- ClosureReturn arm: removed `ty.make_suggestable(tcx, true, placeholder)?`, as the same hunk's second part did (`ty_to_string(self, ty, None)` used unmodified before the fix).
The placeholder plumbing in rustc_middle diagnostics.rs is left in place (unused by these paths).
