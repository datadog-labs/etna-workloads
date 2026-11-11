# Adapted injection for Do not lint unresolved trait for ineffective unstable trait impl

Fix: https://github.com/rust-lang/rust/commit/ed34354bfa4f98da2883fdbba4453c571dde1ef7

compiler/rustc_passes/src/stability.rs, Checker::visit_item (impl-of-trait branch): removed the `of_trait.trait_ref.path.res != Res::Err` condition (and its comment) guarding the INEFFECTIVE_UNSTABLE_TRAIT_IMPL lint.
Re-expresses fix hunk `@@ -748,7 +748,10 @@ impl Visitor for Checker`: `if t.path.res != Res::Err && c.fully_stable {` -> `if c.fully_stable {`.
