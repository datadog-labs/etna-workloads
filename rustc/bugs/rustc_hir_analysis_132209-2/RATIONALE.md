# Adapted injection for Actually do validation for poly trait refs with ? modifier

Fix: https://github.com/rust-lang/rust/commit/e356279bdfe6840236877b298f0c577e0f9221ff

# Rationale
bounds.rs, `lower_bounds` (GenericBound::Trait arm): skip `?Trait` bounds (`BoundPolarity::Maybe`) with `continue` before calling `lower_poly_trait_ref`, so no validation (generic args, path args, relaxed-bound warning) happens for them.
Re-expresses the fix hunk `@@ -168,12 +168,6 @@ ... lower_poly_trait_ref` in bounds.rs, which removed the
`rustc_ast::BoundPolarity::Maybe(_) => continue,` polarity match (the fix moved the Maybe handling into lower_poly_trait_ref after validation). In 1.99.1 lower_poly_trait_ref already handles Maybe with "transient" bounds, so the buggy early skip is re-added at the caller.
