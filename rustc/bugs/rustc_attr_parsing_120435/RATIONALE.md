# Adapted injection for Suggest name value cfg when only value is used for check-cfg

Fix: https://github.com/rust-lang/rust/commit/c36798357d353a8df1bf430ea3261741cfc51121

# compiler/rustc_attr_parsing/src/check_cfg.rs, `unexpected_cfg_name`
The logic moved from rustc_lint diagnostics.rs to here. The `similar_values` computation in the final `else` branch is now gated on `possibilities.is_empty() && !names_possibilities.is_empty()`.
This re-expresses the fix hunk `@@ -261,17 +278,30 @@` (`} else if !possibilities.is_empty() {` became `} else { if !names_possibilities.is_empty() { ... "found config with similar value" ...} if !possibilities.is_empty() {...`).
Before the fix, the "found config with similar value" suggestion was never emitted alongside the expected-names list. Gating it on `possibilities.is_empty()` brings that back.
