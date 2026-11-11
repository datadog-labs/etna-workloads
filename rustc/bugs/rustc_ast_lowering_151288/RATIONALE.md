# Adapted injection for Use find_attr instead of attr::contains_name in lower_const_item_rhs

Fix: https://github.com/rust-lang/rust/commit/db9f9e65013419e87af78c54727f1b4f44bf75b2

# Rationale
File: compiler/rustc_ast_lowering/src/lib.rs, fn `lower_const_item_rhs`.

Fix hunk: `@@ -2384,7 +2384,7 @@` replaced `None if attr::contains_name(attrs, sym::type_const) =>` with `None if find_attr!(attrs, AttributeKind::TypeConst(_)) =>`. That arm handles a body-less type const. The old check missed some type consts, so they fell through to the ordinary `Body` arm.

In 1.99.1 the arm is `(None, ConstItemKind::TypeConst)`. I re-expressed the miss by routing `(None, TypeConst)` into the `Body` arm: `(body, ConstItemKind::Body) | (body @ None, ConstItemKind::TypeConst)`. A body-less type const is no longer detected, as in the buggy parent.
