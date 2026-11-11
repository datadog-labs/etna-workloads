# Adapted injection for diagnostics: account for glob shadowing when linting redundant imports

Fix: https://github.com/rust-lang/rust/commit/000e94e67d2b439c9dc3644c124ae4c405624a14

# Rationale
Upstream code was restructured (ignore_binding -> ignore_decl; shadowed_glob -> separate glob_decl/non_glob_decl), so the fix is re-expressed in compiler/rustc_resolve/src/ident.rs:

1. `single_import_can_define_name`: removed the `if let Some(ignored) = ignore_decl && DeclKind::Import{import,..} = ignored.kind && import == *single_import { continue; }` block. Re-expresses fix hunk `@@ -952,6 +951,14 @@` (adds `if let Some(ignored) = ignore_binding && let NameBindingKind::Import {import,..} = ignored.kind && ptr::eq(import, single_import) { continue; }`).
2. `resolve_ident_in_local_module_non_globs_unadjusted`: added an early `return Err(Break(Determined))` when the primary non-glob decl is the ignored one, rather than continuing on to globs/other scopes. Re-expresses the pre-fix behaviour removed by `@@ -927,15 +929,12 @@` / `@@ -869,17 +869,19 @@` (old `check_usable` returned `Err((Determined, Weak::No))` for an ignored binding instead of falling back to the shadowed glob; fix moved the ignore filtering into `binding` so search continues).
