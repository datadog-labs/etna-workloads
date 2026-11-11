# Adapted injection for Suggest correct `version("..")` predicate syntax in check-cfg

Fix: https://github.com/rust-lang/rust/commit/343fecabc750fa10bc695ad840cfc3ff9bc70830

# Rationale
File: compiler/rustc_attr_parsing/src/check_cfg.rs, fn unexpected_cfg_name (the code moved here from rustc_lint in 1.99.1).
Removed the branch `else if let Some((_value, value_span)) = value && name == sym::version { CodeSuggestion::VersionSyntax {..} }`,
re-expressing the hunk `@@ -140,6 +140,14 @@ pub(super) fn unexpected_cfg_name(` of check_cfg.rs in fix.diff that added it
(the "Suggest correct `version("..")` predicate syntax" branch). Without it, `version = "1.48.0"` no longer gets the `version("..")` suggestion.
The VersionSyntax enum variant/message are left in place (unused).
