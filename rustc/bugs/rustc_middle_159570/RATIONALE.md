# Adapted injection for fix ICE is opsem inhabitedness check

Fix: https://github.com/rust-lang/rust/commit/ec05c7f6a07b09511dab3c51b1b88b37444a5efd

# Rationale
File: compiler/rustc_middle/src/ty/inhabitedness/mod.rs, fn OpsemInhabitedCtx::is_inhabited_ty (match arm).
Re-expresses the fix hunk `@@ -339,8 +339,12 @@ fn is_opsem_inhabited_recursor`: removes the
`ty::Error(_error_guaranteed) => { true }` arm and restores `ty::Error(_) | ty::Infer(..) | ...` falling
into the `bug!("non-normalized type ...")` ICE.
