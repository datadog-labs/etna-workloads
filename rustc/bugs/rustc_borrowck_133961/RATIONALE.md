# Adapted injection for fix crashes

Fix: https://github.com/rust-lang/rust/commit/4d5aaa0f30534943847c84eaf7baffa7fbb9cfe6

# Rationale
The fix's only implementation hunk (`@@ -2230,7 +2230,7 @@ impl<'tcx> RegionDefinition<'tcx>` in region_infer/mod.rs) is a comment rename. The behavioural fix is described by the new test `overwrite-anon-late-param-regions.rs`: anonymous late-bound regions ended up as distinct nll vars that mapped to the same `RegionKind::LateParam`, and the overwritten entry caused an ICE. I re-expressed that on 1.99.1 in `compiler/rustc_borrowck/src/universal_regions.rs`:

- `for_each_late_bound_region_in_item`: the liberated kind is built with `BoundVar 0` instead of the real index, so all anonymous late-bound regions collapse to `LateParamRegionKind::Anon(0)`.
- `replace_bound_regions_with_nll_infer_vars`: same, uses var 0 instead of `br.var`, keeping the lookup consistent.
- `insert_late_bound_region`: the `assert_eq!(..., None)` is replaced by a plain insert, so duplicates silently overwrite the earlier nll var.
