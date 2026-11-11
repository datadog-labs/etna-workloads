# Adapted injection for Check that `#[may_dangle]` is properly applied

Fix: https://github.com/rust-lang/rust/commit/3a9bf4551374893fdc522572ee569028186e22cc

# Rationale
Single hunk: compiler/rustc_passes/src/check_attr.rs, dispatch in `check_attributes` (the `AttributeKind::MayDangle(..)` arm).
It formerly called `self.check_may_dangle(hir_id, *attr_span)`; now it is a no-op `{}` (plus `#[allow(dead_code)]` on `check_may_dangle`).
Re-expresses fix hunk `@@ -189,6 +189,7 @@` (`+ [sym::may_dangle, ..] => self.check_may_dangle(hir_id, attr),`) and `@@ -255,7 +256,6 @@` (removal of `| sym::may_dangle // FIXME(dropck_eyepatch)` from the ignored list), reversed: the parent commit did not validate `#[may_dangle]` placement. The checker fn and error struct/ftl (other hunks) moved in 1.99.1 and are left unused.
