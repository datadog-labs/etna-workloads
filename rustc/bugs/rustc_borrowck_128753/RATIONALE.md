# Adapted injection for Don't arbitrarily choose one upper bound for hidden captured region

Fix: https://github.com/rust-lang/rust/commit/c656ce7aebe23b8d895f485b131da5d296a78c8c

# Rationale
File: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, fn `infer_opaque_types`'s region-folding closure (in `fold_regions`; the fix's file was region_infer/opaque_types.rs).
Fix hunk `@@ -225,21 +225,26 @@`: replaced "pick the first named non-static upper bound" loop with collecting all named non-static upper bounds and only using one if `[universal_region]` is unique, else keeping `region`. I restored the old loop: return the first non-static named upper bound found.
