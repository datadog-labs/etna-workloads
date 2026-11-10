# Adapted injection for Fix #117284, Fix unused variables lint issue for args in macro

Fix: https://github.com/rust-lang/rust/commit/82f34fdd2313b27a4f3e28bed74163154e231b9e

Liveness moved to compiler/rustc_mir_transform/src/liveness.rs (function reporting unused variables).
The fix's liveness.rs hunk `@@ -1652,11 +1651,29 @@` added `from_macro` detection and
`UnusedVariableSugg::NoSugg {..}` (help "captured in macro") instead of `TryPrefixSugg`.
In 1.99.1 the equivalent is the `if from_macro { NoSugg } else { TryPrefix }` logic at two sites;
I changed both conditions to `if false && from_macro`, so macro-introduced variables get the
underscore-prefix suggestion again (old behaviour).
