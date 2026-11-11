# Adapted injection for use correct edition when warning for unsafe attributes

Fix: https://github.com/rust-lang/rust/commit/2c8257493da0e452c03f34cc6f409d98234746db

# Rationale
Upstream fix (`@@ -180,9 +180,14 @@ check_attribute_safety`): `Some(unsafe_since) => attr.span.edition() >= unsafe_since` became `path_span.edition() >= unsafe_since`. In 1.99.1 the logic lives in `compiler/rustc_attr_parsing/src/safety.rs::check_attribute_safety`.

- safety.rs `check_attribute_safety`: added an `outer_attr_span` parameter (the whole attribute's span, incl. `#`) and the edition check now uses `outer_attr_span.edition()` instead of `path_span.edition()`. This restores the old `attr.span.edition()` behaviour.
- interface.rs (two call sites in the attribute-lowering loop, plus `parse_single_args`): pass the whole-attribute span (`attr_span`) as the new argument. Needed because the existing `attr_span` param to the function is the inner item span, not the outer one.
