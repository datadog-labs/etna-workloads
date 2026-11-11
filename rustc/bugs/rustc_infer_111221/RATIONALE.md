# Adapted injection for Tweaks and a test

Fix: https://github.com/rust-lang/rust/commit/6d0b6c0d2cb6eefc8e7b247c3f15b53bd9b0d2ae

# Rationale
File: compiler/rustc_infer/src/infer/relate/generalize.rs (was infer/generalize.rs), `Generalizer::tys` and `Generalizer::consts`.

1. Removed the `ty::ConstKind::Placeholder(placeholder)` arm in `consts`. Re-expresses fix hunk `@@ -421,10 +411,22 @@` which added that arm (`if self.for_universe.can_name(placeholder.universe) { Ok(c) } else { Err(TypeError::Mismatch) }`).
2. Removed the `ty::Placeholder(placeholder)` arm in `tys`, i.e. the universe check on type placeholders (fix hunk `@@ -297,22 +295,17 @@`, `if self.for_universe.can_name(placeholder.universe) { Ok(t) } else {...Err}`). Without it placeholders from a larger universe get generalized through unchecked, so the universe error is lost. (Removing only the const arm did not fail the oracle test, hence this too.)
