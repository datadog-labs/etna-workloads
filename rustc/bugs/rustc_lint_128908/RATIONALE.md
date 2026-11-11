# Adapted injection for diagnostics: do not warn when a lifetime bound infers itself

Fix: https://github.com/rust-lang/rust/commit/4dc13c54714ed854023a03cb9b09b81a6e01f08b

# Rationale
File compiler/rustc_lint/src/builtin.rs, `ExplicitOutlivesRequirements::check_item` (LateLintPass impl).
Re-expresses fix hunks `@@ -2094,7 +2092,11 @@` (lifetimes_outliving_lifetime call) and `@@ -2116,7 +2118,14 @@` (lifetimes_outliving_type call):
the fix added `inferred_outlives.iter().filter(|(_, span)| !predicate.span.contains(*span))` ("don't warn if the inferred span came from the predicate we're looking at; recursive types").
I removed both filters, passing plain `inferred_outlives.iter()`, so recursive types get a spurious lint again.
The signature hunks (impl Iterator params) are kept since they're harmless refactors that the reverted code still uses.
