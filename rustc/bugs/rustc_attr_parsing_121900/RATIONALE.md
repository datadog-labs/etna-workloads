# Adapted injection for Fix misleading message when using a named constant as a struct alignment/pack

Fix: https://github.com/rust-lang/rust/commit/5a5c6dfb33ec9f17416ac96ca66554a033ecd387

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/repr.rs, fn `parse_repr_align`.
In 1.99.1 the fix's builtin.rs hunk (`@@ -1039,21 +1039,37 @@ parse_repr_attr`, the `if nested_items.len() == 1 { ...IncorrectReprFormatExpectInteger ... } else { ...AlignOneArg }`
split, for both align and packed) lives here: a single non-literal argument gets the "expect a literal integer" diagnostic (`expected_integer_literal`).
Reverted to the old behaviour: a non-literal single arg (e.g. `align(N)`, `packed(P)`) emits the generic `expected_single_argument(list.span, ..)` error, i.e. the misleading "takes exactly one argument" message at the whole-list span.
