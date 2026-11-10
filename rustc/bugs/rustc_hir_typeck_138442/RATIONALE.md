# Adapted injection for EUV: fix place of deref pattern's interior's scrutinee

Fix: https://github.com/rust-lang/rust/commit/36ff87e90e7f39cffb508292a63792cc0dcfbd6e

# Rationale
File: compiler/rustc_hir_typeck/src/expr_use_visitor.rs, fn `pat_deref_place` (the old inline code in `cat_pattern_` moved here).
Fix hunk `@@ -1840,7 +1840,8 @@` replaced `let place = self.cat_rvalue(pat.hir_id, ty);` with
`let base = self.cat_rvalue(..); let place = self.cat_deref(pat.hir_id, base)?;`.
Re-injected by returning the bare rvalue (the `&T` temporary) in the `DerefPatBorrowMode::Borrow` arm, dropping the `cat_deref`, so the inner pattern sees the reference type instead of the deref target (slice pattern then ICEs).
