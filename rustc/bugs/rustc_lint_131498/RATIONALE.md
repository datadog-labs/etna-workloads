# Adapted injection for Consider outermost const-anon in non_local_def lint

Fix: https://github.com/rust-lang/rust/commit/7e05da8d42a730c15983bbd56dfbf744b32032d4

# Rationale
File compiler/rustc_lint/src/non_local_def.rs, `NonLocalDefinitions::check_item`, computation of `outermost_impl_parent`.
Re-expresses fix hunk `@@ -148,13 +138,33 @@` (`let outermost_impl_parent = peel_parent_while(... DefKind::Const && name == kw::Underscore)`),
reverted to the old `@@ -124,16 +124,6 @@` form: `parent_parent = if parent is const `_` { Some(tcx.parent(parent)) } else { None }`,
i.e. only a single const-anon level is skipped instead of the outermost chain. (The 1.99 variant also peeled modules; the old code did not, so that is dropped too.)
