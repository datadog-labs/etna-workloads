# Adapted injection for Fix incorrect trait bound restriction suggestion

Fix: https://github.com/rust-lang/rust/commit/9e7345be1f5201634e421aa0963c56a976f36da9

# Rationale
File: compiler/rustc_middle/src/ty/diagnostics.rs, fn suggest_constraining_type_params (closure `suggest_restrict`).
Fix hunk `@@ -274,6 +274,8 @@ pub fn suggest_constraining_type_params`: added
`} else if constraint.starts_with("<") { constraint.to_string()` so that a constraint like `<T = B>` is inserted
verbatim rather than as ` + <T = B>`. In 1.99.1 the code is shaped differently: the `span_to_replace.is_some()` branch
(used by note_and_explain for `<T = B>`) inserts verbatim, and a separate `starts_with('<')` branch exists.
I re-expressed the bug by excluding `<`-constraints from the verbatim branch (`&& !constraint.starts_with('<')`), so they
fall to the ` + {constraint}` path, giving `A: MyTrait + <T = B>`.
