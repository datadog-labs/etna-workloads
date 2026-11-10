# Adapted injection for Don't even parse an intrinsic unless the feature gate is enabled

Fix: https://github.com/rust-lang/rust/commit/651d02a2f06e61fb1a2d67c1f90651db1483a5ca

# Rationale
compiler/rustc_middle/src/ty/util.rs, `intrinsic_raw`: removed the `tcx.features().intrinsics()` check so `#[rustc_intrinsic]` items are treated as intrinsics even without the feature gate.
Re-expresses fix hunk `@@ -1679,10 +1679,15 @@ pub fn is_doc_notable_trait` which added `&& tcx.features().intrinsics` / `&& tcx.features().rustc_attrs` gating to `intrinsic_raw` (the Abi::RustIntrinsic path no longer exists in 1.99.1). The expr.rs hunk (span_bug vs delayed bug) is not re-expressed.
