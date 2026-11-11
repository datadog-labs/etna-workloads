# Adapted injection for resolve: Disable an assert that no longer holds

Fix: https://github.com/rust-lang/rust/commit/b541f1b1983da61eeef8c90edc230edb4eb2581c

# Hunk: compiler/rustc_resolve/src/imports.rs, `select_glob_decl`
In 1.99.1 the larger-visibility glob case is already handled in place (`ambiguity_vis_max.set(Some(glob_decl))`), so the
fix's hunks (`@@ -371,6 +371,8 @@` comment "A glob decl is overwritten by a glob decl with larger visibility. FIXME: avoid this by updating this visibility in place", and `@@ -384,7 +386,8 @@` commenting out `assert!(!deep_decl.is_glob_import())`) no longer reverse.
I re-express the pre-fix state: in the "same item, different visibility" branch, when `vis.greater_than(old_vis)`, return `glob_decl`
(overwrite old glob by the larger-visibility glob) instead of updating in place. The retained `assert!(!deep_decl.is_glob_import())` then fires on re-fetch (issue #152606).
