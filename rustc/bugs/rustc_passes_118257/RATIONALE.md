# Adapted injection for Make traits / trait methods detected by the dead code lint!

Fix: https://github.com/rust-lang/rust/commit/40878ca6ea79d6e55e430846a2de3350a76cd08f

# Rationale
compiler/rustc_passes/src/dead.rs, `DeadVisitor::check_definition`: removed `| DefKind::Trait` from the arm that calls `warn_dead_code(def_id, "used")`.
Re-expresses fix hunk `@@ -948,7 +986,8 @@ impl<'tcx> DeadVisitor<'tcx>` (`+ | DefKind::ForeignTy` / `+ | DefKind::Trait => self.warn_dead_code(def_id, "used")`). Unused traits are no longer reported (pre-fix behaviour).
