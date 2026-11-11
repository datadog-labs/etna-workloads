# Adapted injection for fix ice generics of crate node

Fix: https://github.com/rust-lang/rust/commit/f1a4ae02ed35e9f3c96c8acc9419aeaa8a6747c9

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, in the type-error reporting function (`note_type_err`).

Re-expresses the fix hunk `@@ -1793,12 +1793,13 @@`:
`let body_owner_def_id = (cause.body_id != CRATE_DEF_ID).then(|| cause.body_id.to_def_id());`
Buggy version: always pass `Some(cause.body_def_id.to_def_id())`, even when the body is the crate root.
The `CRATE_DEF_ID` import is removed too (matches the `@@ -55,7 +55,7 @@` import hunk).
`note_and_explain_type_err` then calls `generics_of(crate root)`, which ICEs.
The other hunks (the Option<DefId> plumbing in note_and_explain.rs) are already in 1.99.1 and are harmless without the call-site guard, so I left them.
