# Adapted injection for fix(resolve): update `shadowed_glob` more precision

Fix: https://github.com/rust-lang/rust/commit/f7330eb752cdd83a9b944d1d64a092c7d2454c17

# Rationale
File: compiler/rustc_resolve/src/imports.rs, fn try_plant_decl_into_local_module.

Fix hunk: `@@ -338,7 +338,21 @@ ... resolution.shadowed_glob = Some(glob_binding);` replaced by logic that, when a
`shadowed_glob` already exists and the new glob has a different res, records a GlobVsGlob ambiguity.
Pre-fix behaviour: the later glob simply overwrote the shadowed glob (no ambiguity).
In 1.99.1 `shadowed_glob` no longer exists (separate `glob_decl`/`non_glob_decl`; globs merged via `select_glob_decl`).
Re-injection: when a glob is planted and a non-glob decl already shadows it, and the old glob has a different res,
the new glob replaces the old one instead of going through `select_glob_decl` (which records the ambiguity).
