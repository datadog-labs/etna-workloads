# Adapted injection for Pretty print the name of an future from calling async closure

Fix: https://github.com/rust-lang/rust/commit/ab6f4d62c0aab0f64b663bb572de8a896411b46a

Hunk: compiler/rustc_const_eval/src/util/type_name.rs, `TypeNamePrinter::print_coroutine_with_kind` removed (and the `DefId` import reverted).
Re-expresses fix hunk `@@ -132,6 +132,35 @@ impl<'tcx> Printer<'tcx> for TypeNamePrinter<'tcx>` which added the override that appends `::{{call_once}}`/`::{{call_mut}}`.
Without it, the trait default in rustc_middle (still present, unchanged) prints the kind as a generic arg, so `type_name` gives `...{{closure}}<i32>`-style names instead of the clean ones.
The print/mod.rs hunks were left as is (the default method and call site are harmless without the override).
