# Adapted injection for Use the correct ParamEnv

Fix: https://github.com/rust-lang/rust/commit/aa7edf70739528746d55915b96c63bd3ec43f3a7

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/mod.rs, `select_inherent_assoc_candidates` (the old `probe_inherent_assoc_type` in astconv moved here).
Fix hunk: `@@ -2219,12 +2219,12 @@` in astconv/mod.rs: it removed `let param_env = tcx.param_env(impl_);` (inside the candidate loop) and used `tcx.param_env(block.owner)` instead.
Re-injection: when normalizing and proving the impl's predicates (`predicates_for_generics`), use `tcx.param_env(impl_)` instead of the enclosing body's `self.param_env`. So `T: Clone` in `Container<T>::Proj` is proved under the impl's env, not the user's.
