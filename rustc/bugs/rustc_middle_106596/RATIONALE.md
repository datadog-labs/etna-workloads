# Adapted injection for Hide more of long types in E0271

Fix: https://github.com/rust-lang/rust/commit/f1ffe823cf1496436a1490e838dec375b225b97b

# Rationale
1. compiler/rustc_middle/src/ty/print/pretty.rs, `define_print_and_forward_display!` impls for ProjectionPredicate, SubtypePredicate, CoercePredicate (and not NormalizesTo, which the fix didn't touch): removed `p.reset_type_limit()` between the two halves. Re-expresses fix hunks `@@ -2722,11 +2728,15 @@` / `@@ -2738,7 +2748,9 @@` (`cx.reset_type_limit();` before `print(self.b)` / `print(self.term)`).
2. compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs (report_projection_error): the two "type mismatch resolving `{}`" messages (main message and the label on the assoc type span) print the full `predicate` instead of a length-limited, shortened one. Re-expresses fix hunks `@@ -1724,7 +1724,19 @@` and `@@ -1755,7 +1767,20 @@` (`new_with_limit(... Limit(10)/Limit(5))`; in 1.99.1 this is `tcx.short_string(...)`).
The suggestions.rs cast note hunk was left alone (already shortened code; not needed).
