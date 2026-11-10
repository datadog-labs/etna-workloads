# Adapted injection for Suggest using deref in patterns

Fix: https://github.com/rust-lang/rust/commit/831f4549cd1b23915729cbd2f1dd841621c4e8b8

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, fn `note_error_origin`.
Removed the `else if let Some(param_env) = param_env && let Some(prefix) = self.should_deref_suggestion_on_mismatch(...)` branch that emits
"consider dereferencing to access the inner value using the `Deref` trait". This re-expresses the fix hunk
`@@ -449,22 +457,48 @@ ... note_error_origin` which added that branch (only the box suggestion existed before).
Other parts of the fix (PatternOriginExpr, peeled spans) are left in place, since they are harmless without the branch.
