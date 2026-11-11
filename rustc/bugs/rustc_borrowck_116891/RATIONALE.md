# Adapted injection for reject external lifetimes as invalid arguments

Fix: https://github.com/rust-lang/rust/commit/6b6ed2ea28e591ccae99048f226f98abfcd2e087

# Rationale
File: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, fn `nll_var_to_universal_region` (file moved from region_infer/opaque_types.rs in 1.99.1).
Fix hunk `@@ -162,10 +163,15 @@`: it replaced `.filter(equal).find_map(external_name)` (with the FIXME about external closure regions) by a filter that rejects `RegionClassification::External` regions, then `.find(equal).map(external_name.unwrap())`.
I restored the old code: filter on `equal(vid, ur)` then `.find_map(|ur| external_name)`, with no External-region exclusion. I also removed the `RegionClassification` import, which this left unused (it re-expresses the fix's `+use crate::universal_regions::RegionClassification;` hunk).
