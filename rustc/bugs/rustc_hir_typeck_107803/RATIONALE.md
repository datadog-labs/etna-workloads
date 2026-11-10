# Adapted injection for Do not assemble supertraits for trait aliases

Fix: https://github.com/rust-lang/rust/commit/38ec810c37439a6a3742d85b950978d904b4f826

# Rationale
File: compiler/rustc_hir_typeck/src/method/probe.rs, fn `assemble_extension_candidates_for_trait`, trait-alias branch.

Fix hunk `@@ -951,24 +951,38 @@ impl ProbeContext`: replaced
`let bounds = iter::once(Binder::dummy(trait_ref)); self.elaborate_bounds(bounds, ...)` ("For trait aliases, assume all supertraits are relevant")
with `traits::expand_trait_aliases(...)` ("recursively assume all explicitly named traits are relevant").
I reverted to the old behaviour in 1.99.1 terms: the alias branch now elaborates supertraits
(`traits::supertraits(...)` of the alias, plus the alias ref itself) via `assemble_candidates_for_bounds`,
so supertrait methods (e.g. Debug::fmt through `trait Bar = Foo` where `Foo: Debug`) are brought into scope.
