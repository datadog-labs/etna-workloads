# Adapted injection for Supress unhelpful diagnostics for unresolved top level attributes

Fix: https://github.com/rust-lang/rust/commit/492df34eea0215abb6e3e43dcdcef30df7be23f2

# Rationale
One hunk: compiler/rustc_resolve/src/macros.rs, `finalize_macro_resolutions` (the closure's `else` branch for unresolved/indeterminate macros).
Re-expresses fix hunk `@@ -703,21 +701,21 @@` in macros.rs: the fix changed `} else {` + `if this.privacy_errors.is_empty() { emit_err(CannotDetermineMacroResolution) }` into `} else if has_errors().is_none() && privacy_errors.is_empty() { create_err(...).stash(span, StashKey::UndeterminedMacroResolution) }`.
Reinjected old behaviour: the "cannot determine resolution" error is emitted eagerly whenever there is no privacy error, instead of being stashed (and later cancelled by the crate-level-attribute check) and suppressed when other errors exist. The other fix hunks (StashKey variant, check_attr stealing) already exist in 1.99.1 (rustc_attr_parsing/target_checking.rs) and are left intact (now unused stash).
