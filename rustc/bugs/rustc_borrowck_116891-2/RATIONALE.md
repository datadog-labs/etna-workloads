# Adapted injection for rework opaque types region inference

Fix: https://github.com/rust-lang/rust/commit/f4940e4d22006e902989bbe41ad0484d549495f5

# Rationale
One hunk: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, `nll_var_to_universal_region` (the 1.99.1 descendant of the code in `infer_opaque_types`).
Changed `let vid = rcx.representative(r).rvid();` to `let vid = r;`.
Re-expresses the fix hunk `@@ -138,85 +142,59 @@ ... infer_opaque_types`, which added
`// Use the SCC representative instead of directly using region. let scc = self.constraint_sccs.scc(region.as_var()); let vid = self.scc_representatives[scc];`
Before the fix, regions were looked up directly (no SCC representative), so strictly-equal-region handling was lost.
