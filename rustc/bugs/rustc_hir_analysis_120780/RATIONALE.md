# Adapted injection for Properly check constrainedness of gen params in the presence of weak alias types

Fix: https://github.com/rust-lang/rust/commit/fde4556785ac5e07302a48fcea7ead71e711d5f4

# Rationale
File: compiler/rustc_hir_analysis/src/constrained_generic_params.rs, `parameters_for` and `ParameterCollector::visit_ty`.
In 1.99.1 the fix's logic (walk weak/free aliases to find constrained params) lives in `tcx.expand_free_alias_tys(value)` in `parameters_for`.
Re-expresses fix hunk `@@ -43,26 +45,47 @@ pub fn parameters_for` (the new `ty::Alias(ty::Weak, alias) if !include_nonconstraining` arm that visits the alias's type_of).
Buggy behaviour restored: no expansion; Free aliases are grouped with Projection/Inherent/Opaque as non-injective (pre-fix `ty::Alias(..) if !include_nonconstraining => continue`), and the `bug!("unexpected free alias type")` arm is removed. So params used only through a free alias are treated as unconstrained.
