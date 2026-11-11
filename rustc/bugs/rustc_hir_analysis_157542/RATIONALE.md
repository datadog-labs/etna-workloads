# Adapted injection for Reject `#[repr(packed)]` on `#[pin_v2]` types

Fix: https://github.com/rust-lang/rust/commit/9e9a031dc8d299deb2595a851dd85667a73cb867

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs, fn `check_packed`.
Removed the block `if def.is_pin_project() { emit_err(PinV2OnPacked{..}) }` inside `if repr.packed() {`,
re-expressing fix hunk `@@ -1633,6 +1633,18 @@ pub(super) fn check_packed` (which added that check). The error struct
(now in diagnostics.rs) is left in place, unused.
