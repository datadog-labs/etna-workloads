# Adapted injection for Make lint missing-copy-implementations honor negative Copy impls

Fix: https://github.com/rust-lang/rust/commit/2b8a3b44bfa63c729841c29d70cc2d3e66ca3842

compiler/rustc_lint/src/builtin.rs, `MissingCopyImplementations::check_item`: removed the early return
`if type_implements_negative_copy_modulo_regions(cx.tcx, ty, cx.typing_env()) { return; }`.
This re-expresses fix hunk `@@ -710,6 +712,9 @@ impl LateLintPass for MissingCopyImplementations`, which added that check after `is_copy_modulo_regions`.
The helper fn (fix hunk `@@ -745,6 +750,24 @@`) is kept with `#[allow(dead_code)]` to avoid an unused warning.
