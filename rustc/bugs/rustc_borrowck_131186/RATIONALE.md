# Adapted injection for Try to point out when edition 2024 lifetime capture rules cause borrowck issues

Fix: https://github.com/rust-lang/rust/commit/c1457798db03ffb7f207eaf208d8d4d77ba01563

# Rationale
In 1.99.1 the logic lives in compiler/rustc_borrowck/src/diagnostics/opaque_types.rs (left intact, now unused).
I removed the five call sites in `conflict_errors.rs` (report_use_while_mutably_borrowed, report_mutability_error-style borrow errors, report_conflicting_borrow, report_borrowed_value_does_not_live_long_enough, report_illegal_mutation_of_borrowed). Each re-expresses a fix hunk adding
`+ self.note_due_to_edition_2024_opaque_capture_rules(borrow, &mut err);` (hunks @@ -1489, -1561, -1820, -2939, -3777). The parent behaviour therefore never emits the "this call may capture more lifetimes than intended" note / use<..> suggestion.
