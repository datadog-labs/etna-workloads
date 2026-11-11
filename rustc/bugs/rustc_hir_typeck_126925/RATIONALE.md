# Adapted injection for Change E0369 diagnostic give note information for foreign items.

Fix: https://github.com/rust-lang/rust/commit/2a6a42329f79d3c2a42f23ca9fb68aba511a2bc1

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `note_unmet_impls_on_type`.
Re-expresses fix hunks `@@ -2788,32 +2788,38 @@` .. `@@ -2833,24 +2838,69 @@`: the fix split preds into local/foreign and added a
second note ("the foreign item type ... doesn't implement ...") for foreign ADTs, and no longer required all types be local
(`all_local_types_needing_impls`) for the local note.
Bug re-injected: the foreign-item note loop is removed, and the local note is only emitted when no foreign preds exist
(equivalent to the old all-local gate). So E0369 on foreign types gives no note.
