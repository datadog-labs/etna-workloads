# Adapted injection for Keep track of patterns that could have introduced a binding, but didn't

Fix: https://github.com/rust-lang/rust/commit/0f82cfffda97be546949f974586d007b51e2b36e

# Rationale
File: compiler/rustc_resolve/src/late.rs, fn `record_patterns_with_skipped_bindings`.
Fix hunk `@@ -3821,6 +3827,27 @@` added this fn with arm `ast::PatFieldsRest::Rest | ast::PatFieldsRest::Recovered(_) =>` recording the pattern in `patterns_with_skipped_bindings`.
Bug: the `Rest` (`..`) variant is moved to the no-op arm, so only recovered patterns are recorded; `Foo { a, .. }` no longer yields the "has a field `x` which could have been included" note/label for missing bindings.
Other fix hunks (ast enum, parser, lowering, pretty printer, diagnostics) were left intact.
