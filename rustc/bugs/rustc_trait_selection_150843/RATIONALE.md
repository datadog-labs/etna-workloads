# Adapted injection for mGCA: Permit certain const projections in dyn-compatible traits

Fix: https://github.com/rust-lang/rust/commit/7777958231d3eee422b5c57b82f762d5a96f8bde

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, `IllegalSelfTypeVisitor::visit_const`.
Re-expresses fix hunk `@@ -747,82 +750,88 @@ ... fn visit_const`: the fix replaced
`self.tcx.expand_abstract_consts(ct).super_visit_with(self)` with a match on `ConstKind::Unevaluated` projections
(under min_generic_const_args) that allows supertrait const projections. I restored the old body, so Self-const
projections of supertraits are rejected as illegal Self references. The type-side refactor (is_supertrait_of_current_trait) was kept as it is behaviour-neutral.
