# Adapted injection for Treat TAIT equation as always ambiguous in coherence

Fix: https://github.com/rust-lang/rust/commit/d43683f2e905d34ab289882c16124deb5ed09edd

# Rationale
Fix hunk: `compiler/rustc_infer/src/infer/combine.rs` `@@ -124,13 +124,10 @@`: changed the coherence arm from
`(Alias(Opaque a_def_id), Alias(Opaque b_def_id)) if self.intercrate && a_def_id == b_def_id` (ambiguous only for same opaque)
to `(Alias(Opaque,_), _) | (_, Alias(Opaque,_)) if self.intercrate` (ambiguous against any type).
The bug re-injected is the parent behaviour: opaque only "possibly equal" to the same opaque.

1. `compiler/rustc_type_ir/src/relate/combine.rs`, `super_combine_tys` (old-solver coherence arm, the direct descendant of the fix hunk):
   guard restricted so the Ambiguous predicate is only registered when both sides are opaques with equal def_id. (Dead for the oracle since coherence uses the next solver by default, but is the literal analog.)
2. `compiler/rustc_next_trait_solver/src/solve/project_goals/opaque_types.rs`, `normalize_opaque_type`, `TypingMode::Coherence` arm:
   in coherence 1.99 uses the new solver, where the "ambiguous against any type" behaviour lives here (nested `PredicateKind::Ambiguous`). Now it is only added if `expected` is an opaque with the same def_id; otherwise the opaque is equated as rigid (so it is unequal to `Foo`), restoring the pre-fix "only ambiguous with itself" behaviour. Oracle test no longer reports the E0119 overlap.
