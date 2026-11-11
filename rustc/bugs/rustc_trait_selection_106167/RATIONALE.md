# Adapted injection for Fix invalid syntax in impl Trait parameter type suggestions for E0311

Fix: https://github.com/rust-lang/rust/commit/621d4122413b371b0aaa53480d8efd80c4b5f0ba

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/region.rs, fn `suggest_name_region`.
The fix (`@@ -2187,11 +2190,64 @@`) replaced
`generics.params.first()...(def_span(def_id).shrink_to_lo(), "{new_lt}, ")` (which inserted `'a, ` before
a synthetic `impl Trait` param, producing invalid syntax) with an `is_synthetic` branch that inserts `<'a>` at
the generics span instead. In 1.99.1 the equivalent is `span_for_lifetime_suggestion()`, which guards
with `self.span.contains(first.span)` (excluding synthetic params, falling back to `<'a>`).
I re-introduced the old behaviour: always use the first generic param's span, `'a, `, even if synthetic.
