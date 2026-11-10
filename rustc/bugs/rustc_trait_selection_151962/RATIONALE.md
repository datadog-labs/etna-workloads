# Adapted injection for fix next-solver ICE on PointeeSized goals

Fix: https://github.com/rust-lang/rust/commit/66786fc407e79f013c6f0f256f36de7efcd96ae0

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, fn check_same_name_different_path.
Removed the guard `&& !self.tcx.is_lang_item(def_id, LangItem::PointeeSized)` (with its comment "`PointeeSized` is removed during lowering.").
Re-expresses fix hunk `@@ -2632,6 +2632,8 @@ impl<'a, 'tcx> TypeErrCtxt<'a, 'tcx>` which added that line. Without it, a user trait named PointeeSized matches the lang-item PointeeSized and the next-solver ICEs.
