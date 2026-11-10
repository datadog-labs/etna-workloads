# Adapted injection for Untruthful multiple different versions of a crate in the dependency graph

Fix: https://github.com/rust-lang/rust/commit/b25336b0105b3f1fece5d0991dfae89be9d64aa6

All changes are in compiler/rustc_trait_selection/src/error_reporting/traits/mod.rs. They reverse the fix's three code hunks by hand.

1. Imports. This reverses the fix hunks `@@ -12,7 +12,7 @@` (`LOCAL_CRATE`) and `@@ -22,7 +22,8 @@` (`ExternCrate`, `Symbol`). I dropped `LOCAL_CRATE` and `ExternCrate` and re-added `Symbol`.
2. `extern_crates_with_the_same_name` is replaced by the old `get_extern_crate_renamed_symbol`. This reverses the fix hunk `@@ -353,14 +354,37 @@`. The old function returns the `extern crate` item name when the source is `ExternCrateSource::Extern`. It returns None for `Path` sources, and it does not check `dependency_of`.
3. `check_same_definition_different_crate` gets `locally_renamed_krate` back. The filter compares `locally_renamed_krate == self.get_extern_crate_renamed_symbol(def_id)`. This reverses the fix hunk `@@ -377,13 +401,10 @@`. If both crates are imported via `ExternCrateSource::Path`, both sides are None and compare equal, so the compiler reports a false "multiple versions of crate" diagnostic.
