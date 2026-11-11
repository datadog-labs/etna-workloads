# Adapted injection for avoid duplicate diagnostic args in `RegionOriginNote::WithName`

Fix: https://github.com/rust-lang/rust/commit/989f4cd126d34cc233ec091abd492fa190279243

# Rationale
File: compiler/rustc_trait_selection/src/diagnostics.rs (was errors.rs upstream), `impl Subdiagnostic for RegionOriginNote`, arm `WithName`.
Re-expresses fix hunk `@@ -442,9 +442,11 @@ impl Subdiagnostic for RegionOriginNote<'_>`: the fix replaced
`diag.arg("name", name); diag.arg("continues", continues); label_or_note(diag, span, msg);` with
`label_or_note(diag, span, msg.arg("name", name).arg("continues", continues).format())`.
I restored the old form (args set on the diag, causing duplicate diagnostic args).
