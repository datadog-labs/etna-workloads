# Adapted injection for Fix --check-cfg bug with args order when parsing

Fix: https://github.com/rust-lang/rust/commit/f4ca42f573e3a8bd9bb5099efa0285855b77367f

# Rationale
File: compiler/rustc_interface/src/interface.rs, fn parse_check_cfg, the `.and_modify` on `check_cfg.expecteds.entry(name.name)` in the `cfg(...)` handling.
Fix hunk `@@ -173,12 +173,21 @@ pub fn parse_check_cfg` added an `.and_modify(...)` so repeated `--check-cfg` specs for one name merge regardless of order. In 1.99.1 that logic is the `ExpectedValues::Some(v)` arm of the existing `and_modify`. I replaced `v.extend(values.clone())` with `*v = values.clone()`. A later spec for the same name now overwrites earlier values, so the result depends on argument order.
