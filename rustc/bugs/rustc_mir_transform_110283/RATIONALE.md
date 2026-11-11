# Adapted injection for Only emit alignment checks if we have a panic_impl

Fix: https://github.com/rust-lang/rust/commit/4061eb589797ab4498f00ba0be337e4a1355cb49

# Rationale
File: compiler/rustc_mir_transform/src/check_pointers.rs, fn `check_pointers`.
In 1.99.1 the alignment pass's body was moved into the shared `check_pointers`, and the fix's guard now lives there.
Removed the early return `if tcx.lang_items().get(LangItem::PanicImpl).is_none() { return; }`.
This re-expresses the fix hunk `@@ -17,6 +18,12 @@ impl<'tcx> MirPass<'tcx> for CheckAlignment` in check_alignment.rs which added that guard to `run_pass`.
Result: alignment checks are emitted without a panic_impl (bug #109996).
