# Adapted injection for resolve: Relax some asserts in glob overwriting and add tests

Fix: https://github.com/rust-lang/rust/commit/8b52c73b3ec29dadf5df8dc02aeea5aeea778fd7

# Rationale
File compiler/rustc_resolve/src/imports.rs, fn `remove_same_import` (fix hunk `@@ -300,13 +300,13 @@ fn remove_same_import`).
Restored the pre-fix strictness: re-added the guard `&& d1.warn_ambiguity == d2.warn_ambiguity` (in 1.99.1 the warning flag lives in `ambiguity: Option<(Decl, bool)>`, so it is `ambiguity.is_some_and(|a| a.1)`), `assert!(!d1.warn_ambiguity.get())`, `assert_eq!(d1.ambiguity.get(), d2.ambiguity.get())` (replacing the relaxed check), and `assert_eq!(d1.vis(), d2.vis())` (removed by the fix with the comment about visibility differing).
