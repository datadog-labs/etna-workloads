# Adapted injection for Fix handling of x18 in AArch64 inline assembly on ohos/trusty or with -Zfixed-x18

Fix: https://github.com/rust-lang/rust/commit/687dc19cb60096d5feb789264f7d61d8b68de884

# Rationale
One hunk: compiler/rustc_target/src/asm/aarch64.rs, `target_reserves_x18`.
Re-expresses fix hunk `@@ -71,18 +71,26 @@ ... pub(crate) fn target_reserves_x18`: the fix added `|| target.env == "ohos"` and
`|| target_features.contains(&sym::reserve_x18)`. I removed both (param renamed `_target_features`), restoring the old
behaviour where `-Zfixed-x18`/`+reserve-x18` targets (trusty) are not seen as reserving x18, so clobber_abi("C") wrongly clobbers x18.
Other fix hunks (signature plumbing, symbol, target feature, ohos spec) already exist in 1.99.1 and were left alone.
