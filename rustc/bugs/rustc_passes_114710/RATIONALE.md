# Adapted injection for Respect `#[expect]` the same way `#[allow]` is with the `dead_code` lint

Fix: https://github.com/rust-lang/rust/commit/d801a2ff1565c96d016c4ac783f2d83b967d8ae7

# Rationale
compiler/rustc_passes/src/dead.rs, `has_allow_dead_code_or_lang_attr::has_allow_expect_dead_code`:
changed `matches!(lint_level, lint::Allow | lint::Expect)` back to `lint_level == lint::Allow`.
Re-expresses the fix hunk `@@ -537,9 +575,13 @@ / -513,16 +547,20 @@` where
`tcx.lint_level_at_node(DEAD_CODE, hir_id).0 == lint::Allow` became
`matches!(lint_level, lint::Allow | lint::Expect(_))`. The rest of the ComesFromAllowExpect machinery already exists in 1.99.1 and is left intact; `#[expect(dead_code)]` items are no longer treated as allow-like, so they get reported/unfulfilled.
