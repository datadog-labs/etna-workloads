# Adapted injection for Fix unused_parens false positive

Fix: https://github.com/rust-lang/rust/commit/e958b20af7ad3e3a053070a9c45389fe463ccc0c

compiler/rustc_lint/src/unused.rs, UnusedParens::check_ty_pre (TyKind::Ref | TyKind::Ptr arm).
Re-expresses fix hunk `@@ -1340,7 +1341,11 @@ impl EarlyLintPass for UnusedParens`: the fix propagated the type's own
no-bounds constraint (`own_constraint = self.in_no_bounds_pos.get(&ty.id)`) to the pointee; the buggy parent
always inserted `NoBoundsException::OneBound`. Reinjected by dropping the own-constraint lookup (1.99.1 had
it as a match). The `#[derive(Copy, Clone)]` hunk is not needed (the 1.99.1 code matches rather than copies).
