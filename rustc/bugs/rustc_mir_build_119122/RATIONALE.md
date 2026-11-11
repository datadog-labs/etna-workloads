# Adapted injection for Give temporaries in if let guards correct scopes

Fix: https://github.com/rust-lang/rust/commit/d437a111f5c08cd85fb5eebecd9d2112a84610a4

# Rationale
File: compiler/rustc_mir_build/src/builder/matches/mod.rs (lower_match_arms): `mem::replace(&mut this.fixed_temps_scope, guard_scope)` changed to `mem::replace(&mut this.fixed_temps_scope, None)`.
Re-expresses fix hunk `@@ -396,6 +396,9 @@` in build/matches/mod.rs, which added `mem::replace(&mut this.fixed_temps_scope, Some(arm.scope))`. Without it, guard temporaries are never deduplicated, so an or-pattern's duplicated if-let guard creates distinct MIR temps per copy (the pre-fix bug).
