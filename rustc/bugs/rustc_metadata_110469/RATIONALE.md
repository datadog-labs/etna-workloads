# Adapted injection for Encode lifetime param spans too

Fix: https://github.com/rust-lang/rust/commit/24c2c075cc2216af8868809fdd68c9da8466c327

# Rationale
File compiler/rustc_metadata/src/rmeta/encoder.rs, fn `should_encode_span`.
Re-expresses both hunks of fix.diff (`@@ -824,6 +824,7 @@ fn should_encode_span` which adds `| DefKind::LifetimeParam` to the true list, and `@@ -840,10 +841,7 @@` which removed it from the false arm): LifetimeParam is moved back from the `=> true` group to the `ForeignMod | GlobalAsm => false` arm, so lifetime param spans are not encoded cross-crate.
