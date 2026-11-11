# Adapted injection for `rustc_hir_typeck`: Account for `skipped_ref_pats` in `expr_use_visitor`

Fix: https://github.com/rust-lang/rust/commit/fe8f66e4bcbe36e7e4b21943661ff23b5369c64b

In compiler/rustc_hir_typeck/src/expr_use_visitor.rs (the fix's hunks #1 import reorder is cosmetic, not reproduced):
- `pat_ty_adjusted`: removed the `else if let PatKind::Ref(subpat,_,_) = pat.kind && skipped_ref_pats().contains(pat.hir_id) { return self.pat_ty_adjusted(subpat); }` branch (fix hunk `@@ -1181,6 +1181,10 @@`).
- `cat_pattern`: removed the `PatKind::Ref(subpat, _, _) if skipped_ref_pats().contains(..) => cat_pattern(place_with_id, subpat, op)` arm (fix hunk `@@ -1712,6 +1716,12 @@`), so skipped ref patterns get an extra deref.
