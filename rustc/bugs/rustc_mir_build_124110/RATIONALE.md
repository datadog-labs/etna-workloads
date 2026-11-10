# Adapted injection for Fix negating `f16` and `f128` constants

Fix: https://github.com/rust-lang/rust/commit/cc12a1b5119b003132a16e83c19642bb6584f2df

# Rationale
File: compiler/rustc_mir_build/src/builder/mod.rs (moved from build/mod.rs), fn `parse_float_into_scalar`.
Re-expresses both fix hunks (`@@ -1023,7 +1023,13 @@` F16 arm and `@@ -1071,7 +1077,13 @@` F128 arm):
the fix added `let mut f = num.parse::<Half>().ok()?; if neg { f = -f; }`. I restored the old
behaviour: `num.parse::<Half>().ok().map(ScalarInt::from)` and likewise for `Quad`, ignoring `neg`.
