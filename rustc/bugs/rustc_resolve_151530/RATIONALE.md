# Adapted injection for Fix invalid `mut T` suggestion for `&mut T` in missing lifetime error

Fix: https://github.com/rust-lang/rust/commit/e0d9d470df00ecbe07bb5ddfec2ab6083aa3025f

# Rationale
All changes in compiler/rustc_resolve/src/late/diagnostics.rs (the fix's only implementation file).

- `report_missing_lifetime_specifiers` (owned-value suggestion, `if owned_sugg {`): removed the call to
  `find_ref_prefix_span_for_owned_suggestion(lt.span)` that overrides `sugg` with the full `&mut ` prefix span.
  Re-expresses fix hunk `@@ -3935,6 +3944,12 @@` (`if let Some(span) = self.find_ref_prefix_span_for_owned_suggestion(lt.span) && !sugg_is_str_to_string { sugg = vec![(span, String::new())]; }`).
  Without it, `&mut T` only has the `&` removed, giving the invalid `mut T` suggestion (and `str` instead of `String` isn't affected by flag).
- Removed the now-dead `sugg_slice_to_vec_or_string` flag (1.99.1 name of fix's `sugg_is_str_to_string`, hunks `@@ -3875`/`-3901`), which only guarded that call.
- Removed the helper `find_ref_prefix_span_for_owned_suggestion` and `RefPrefixSpanFinder` (fix hunks `@@ -3961,6 +3976,23 @@` and `@@ -4058,6 +4090,26 @@`), to avoid dead-code warnings.
