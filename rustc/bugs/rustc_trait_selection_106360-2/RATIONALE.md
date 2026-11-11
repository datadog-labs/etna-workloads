# Adapted injection for Make `&`-removal suggestion verbose

Fix: https://github.com/rust-lang/rust/commit/2024aa48b4e92894e6f780a13c03db7605e1a5f2

# Rationale
One hunk: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, `suggest_remove_reference` (the closure that emits the "consider removing N leading `&`-references" suggestion).

Re-expresses fix hunk `@@ -1388,25 +1403,33 @@` in which `err.span_suggestion_short(sp, &msg, "", MachineApplicable)` became `err.multipart_suggestion_verbose(&msg, suggestions, MachineApplicable)`.
In 1.99.1 the call is `multipart_suggestion`, which is ShowAlways, i.e. verbose. I changed it to `multipart_suggestion_with_style(..., SuggestionStyle::HideCodeInline)`, which is the inline short style the pre-fix code used. The suggestion is again rendered inline (`help: consider removing the leading &-reference` on the label) rather than as a separate verbose diff.
The span-computation part of the fix (AddrOf walk) already exists in 1.99.1 and was not touched.
