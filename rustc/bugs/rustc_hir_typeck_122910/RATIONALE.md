# Adapted injection for Validate that we're only matching on unit struct for path pattern

Fix: https://github.com/rust-lang/rust/commit/08235b1603f77f39468e7b2e552945501c0cc048

# Rationale
File compiler/rustc_hir_typeck/src/pat.rs, fn resolve_pat_path (was check_pat_path in the fix).
Re-expresses the single fix hunk `@@ -919,8 +919,25 @@`: the fix split `Res::SelfCtor(..) | Res::Def(...)` into a dedicated
`Res::SelfCtor(def_id)` arm that only accepts unit structs (E0533 "unit struct" otherwise). I removed that arm and merged
`Res::SelfCtor(..)` back into the always-OK arm, so tuple/struct `Self` in patterns is no longer rejected here.
