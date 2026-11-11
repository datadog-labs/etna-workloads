# Adapted injection for Detect out of bounds range pattern value

Fix: https://github.com/rust-lang/rust/commit/52d534ef63294d93d3b3f711297e962396d5e0e4

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/mod.rs, fn `lower_pattern_range` (the fallback `_ =>` arm for empty ranges).
Removed the calls `self.error_on_literal_overflow(lo_expr, ty)?;` and `self.error_on_literal_overflow(hi_expr, ty)?;`.
Re-expresses fix hunks `@@ -141,7 +151,27 @@` / `@@ -152,10 +182,34 @@` (the `lower_overflow`/`higher_overflow` checks emitting `LiteralOutOfRange`
before `LowerRangeBoundMustBeLessThanUpper(OrEqual)`). Without them, out-of-bounds literals like `251..257` give the
misleading "lower range bound must be less than upper" error instead of "literal out of range" (issue #68972).
The helper, error struct and ftl message already exist in 1.99.1 (the fix's other hunks), so only the call sites were removed.
