# Adapted injection for Never consider raw pointer casts to be trival

Fix: https://github.com/rust-lang/rust/commit/b6657a8ad43baf28a540879af55d588b7bb29029

# Hunk: compiler/rustc_hir_typeck/src/cast.rs, CastCheck::check_cast (the `try_coercion_cast` Ok arm)
Fix hunk `@@ -660,9 +660,21 @@ impl<'a, 'tcx> CastCheck<'tcx>` added `if self.expr_ty.is_unsafe_ptr() && self.cast_ty.is_unsafe_ptr() { debug!(" -> PointerCast") } else { trivial_cast_lint; set_coercion_cast }`.
In 1.99.1 the same code uses `is_raw_ptr()`. I removed the raw-ptr special case, so raw-pointer casts that succeed as coercions are again recorded as coercion casts (trivial), restoring the old behaviour (#113257).
