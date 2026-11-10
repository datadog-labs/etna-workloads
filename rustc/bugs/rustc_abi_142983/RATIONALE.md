# Adapted injection for Add rust-invalid ABI

Fix: https://github.com/rust-lang/rust/commit/e245570def155191b61f73647eb543dd45685b2f

The fix added the `RustInvalid` ("rust-invalid") ABI; the bug is its absence. All hunks remove it again (variant and every use):
- rustc_abi/src/extern_abi.rs: removed `RustInvalid` variant (fix hunk `@@ -36,6 +36,10 @@ pub enum ExternAbi`), its `RustInvalid =><= "rust-invalid"` string mapping (`@@ -157,6 +161,7 @@ abi_impls!`), and the `Self::RustInvalid` arm in a match (in 1.99.1 only).
- rustc_ast_lowering/src/stability.rs: removed the `ExternAbi::RustInvalid => Err(UnstableAbi{..rustc_attrs..})` arm (`@@ -96,6 +96,9 @@ extern_abi_stability`).
- rustc_middle/src/ty/layout.rs fn_can_unwind: removed `| RustInvalid` (`@@ -1253,7 +1253,8 @@`).
- rustc_target/src/spec/abi_map.rs: removed `(ExternAbi::RustInvalid, _) => return AbiMapping::Invalid` (`@@ -156,7 +156,8 @@ impl AbiMap`, `| ExternAbi::RustInvalid`).
- rustc_public (renamed rustc_smir/stable_mir): ty/tys.rs variant, convert/internal.rs and convert/stable/ty.rs conversions (the three smir hunks).
