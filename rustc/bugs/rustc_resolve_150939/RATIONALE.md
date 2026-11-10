# Adapted injection for resolve: Relax one more assert in glob overwriting and add a test

Fix: https://github.com/rust-lang/rust/commit/83c5f2c19409deb44778bc6ad36a33f3b9ce0f57

File: compiler/rustc_resolve/src/imports.rs (1.99.1 already contained the fix in a slightly different form; both hunks reverted).

1. `remove_same_import`: fix hunk `@@ -301,9 +301,12 @@` removed `assert_eq!(d1.ambiguity.get(), d2.ambiguity.get());` and replaced it with a relaxed `if d1.ambiguity != d2.ambiguity { assert!(is_some) ...}`. Restored the strict `assert_eq!` on ambiguity (dropped the relaxed check).
2. Glob overwrite re-fetch in `update_resolution`/glob-overwrite code: fix hunk `@@ -377,6 +380,10 @@` added "Do not lose glob ambiguities when re-fetching the glob" (copy old ambiguity to the new glob_decl). Removed that block.
