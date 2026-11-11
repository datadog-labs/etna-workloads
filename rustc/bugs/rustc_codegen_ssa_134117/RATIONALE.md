# Adapted injection for Simplify the GEP instruction for index

Fix: https://github.com/rust-lang/rust/commit/3fc506b4d43938453fd399f403507e4b2031a167

# Hunk
compiler/rustc_codegen_ssa/src/mir/place.rs, `PlaceRef::project_index`.
Re-expresses fix hunk `@@ -422,10 +422,7 @@ impl PlaceRef`: the fix changed
`inbounds_gep(backend_type(self.layout), llval, &[const_usize(0), llindex])` to
`inbounds_gep(backend_type(layout), llval, &[llindex])`. I restored the old form (array/slice type with a `[0, idx]` two-index GEP), keeping 1.99.1's `inbounds_nuw_gep`.
