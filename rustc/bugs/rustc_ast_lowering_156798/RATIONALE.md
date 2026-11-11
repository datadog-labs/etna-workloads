# Adapted injection for Do not always generate first delegation argument

Fix: https://github.com/rust-lang/rust/commit/31e358824f82fa9c9964971645df2eee44449401

# Re-injection

File: compiler/rustc_ast_lowering/src/delegation/resolution.rs, `create_sig_mapping`.

In 1.99.1 the fix's logic (`should_generate_block`, formerly in delegation.rs) lives in resolution.rs. `create_sig_mapping` only maps the target expression onto argument 0 when `should_generate_block` is true:
`if should_generate_block { mapping.arguments_to_map.insert(0); }`.
I made the insert unconditional, so the first argument is always generated from the target expression.

This re-expresses the fix hunk in delegation.rs `@@ -437,6 +524,7 @@ ... lower_delegation_body`, which added `&& this.should_generate_block(delegation, sig_id, is_method)` to the `if let Some(block) = block && idx == 0` condition. The title is "Do not always generate first delegation argument".
