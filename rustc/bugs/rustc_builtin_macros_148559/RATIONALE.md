# Adapted injection for Add typo suggestion for a misspelt Cargo environment variable

Fix: https://github.com/rust-lang/rust/commit/3edd25f04962dd37bd4d0f460883d0c16ff480d4

# Rationale
compiler/rustc_builtin_macros/src/env.rs, `expand_env`: removed the branch
`else if let Some(suggested_var) = find_similar_cargo_var(var) && suggested_var != var { ... EnvNotDefined::CargoEnvVarTypo ... }`.
This re-expresses fix hunk `@@ -144,6 +145,12 @@ pub(crate) fn expand_env` (added `else if let Some(suggested_var) = find_similar_cargo_var(...)` emitting `CargoEnvVarTypo`).
Added `#[allow(dead_code)]` on `find_similar_cargo_var` so it builds without warnings-as-errors (the helper/const/diagnostic variant were the other fix hunks; left in place, unused).
