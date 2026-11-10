# Adapted injection for Opaques do not constrain generic params

Fix: https://github.com/rust-lang/rust/commit/d0c826cfc2a1d52061a5c72d2dd78a06b51374ce

# Hunk: compiler/rustc_hir_analysis/src/constrained_generic_params.rs, ParameterCollector::visit_ty
Fix hunk `@@ -59,7 +59,7 @@ impl TypeVisitor for ParameterCollector`:
`-ty::Alias(ty::Projection | ty::Inherent, ..) if !self.include_nonconstraining`
`+ty::Alias(..) if !self.include_nonconstraining`
i.e. the fix made opaque types non-constraining. In 1.99.1 the pattern is `kind: Projection|Inherent|Opaque`; I removed `ty::Opaque { .. }`, so opaque type args again count as constrained params (the bug).
