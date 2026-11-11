# Adapted injection for unused_must_use: Don't warn on `Result<(), Uninhabited>`

Fix: https://github.com/rust-lang/rust/commit/6f89cecf3756c276dbd263810e86c13a652dbb5a

# Hunk: compiler/rustc_lint/src/unused/must_use.rs, `is_ty_must_use`
Removed the match arm `ty::Adt(def, args) if is_diagnostic_item(sym::Result, ..) && is_uninhabited(args.type_at(1))` (which recursed into the Ok type and wrapped in `MustUsePath::Result`).
Re-expresses fix.diff hunk `@@ -291,6 +291,18 @@ impl<'tcx> LateLintPass<'tcx> for UnusedResults` which added
"Suppress warnings on `Result<(), Uninhabited>`" (`args.type_at(0).is_unit() && !args.type_at(1).is_inhabited_from(..)`). Without it, `Result<(), !>` falls to `is_def_must_use` and warns again.
