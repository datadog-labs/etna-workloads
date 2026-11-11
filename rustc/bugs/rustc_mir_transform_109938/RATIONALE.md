# Adapted injection for Move a const-prop-lint specific hack from mir interpret to const-prop-lint and make it fallible

Fix: https://github.com/rust-lang/rust/commit/b5d96d5ec5388b89c700b4b9e6f7f73afa9cbcb1

# Rationale
File: compiler/rustc_mir_transform/src/known_panics_lint.rs, fn `KnownPanicsLint::eval_constant` (1.99.1 successor of const_prop_lint.rs).
Re-expresses hunk `@@ -284,7 +284,15 @@ impl ConstPropagator` in const_prop_lint.rs, which changed the lint's normalization to
`self.tcx.try_normalize_erasing_regions(self.param_env, c.literal).ok()?` (fallible). The bug is the parent's infallible
normalization (`normalize_erasing_regions`), which ICEs ("Failed to normalize ...") on issue-109743. I restored the infallible call in the lint.
The operand.rs hunk (moving normalization out of the interpreter) no longer exists in 1.99.1, so there is nothing to revert there; the normalize_erasing_regions.rs hunk was formatting only.
