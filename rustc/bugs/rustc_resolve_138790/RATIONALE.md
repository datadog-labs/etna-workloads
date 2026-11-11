# Adapted injection for Note potential but private items in show_candidates

Fix: https://github.com/rust-lang/rust/commit/26cfa6f819e10fa597766d8c5549b86e503ff288

Files: compiler/rustc_resolve/src/diagnostics/impls.rs (diagnostics.rs was split into diagnostics/impls.rs in 1.99.1).

1. `lookup_import_candidates_from_module` end: re-added
   "If only some candidates are accessible, take just them / candidates.retain(|x| x.accessible)".
   Re-expresses hunk `@@ -1325,11 +1325,6 @@` (removed that retain).
2. `show_candidates`: restored `} else if !(inaccessible_path_strings.is_empty() || matches!(mode, DiagMode::Import { .. })) {`
   in place of the independent `if !inaccessible_path_strings.is_empty() && !matches!(mode, Import{unresolved_import:false,..})`.
   Re-expresses hunk `@@ -2959,8 +2957,11 @@` : inaccessible items are no longer noted when accessible candidates were shown, nor for any Import mode.
   (The `unresolved_import` field is left in place, now unused in the condition; `showed` variable remains, behaviourally equivalent to old true/false returns.)
