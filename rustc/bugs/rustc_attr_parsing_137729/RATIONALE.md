# Adapted injection for fix ICE on stable related to attrs on macros

Fix: https://github.com/rust-lang/rust/commit/48a4e2d2dde8d68e1d00d3eac07b2c6155f3239d

# Rationale
File compiler/rustc_attr_parsing/src/parser.rs, fn expr_to_lit, non-literal-expr branch.
Fix hunk `@@ -355,6 +355,10 @@ fn expr_to_lit` added `if matches!(should_emit, ShouldEmit::Nothing) { return None; }` before building the "attribute value must be a literal" error.
In 1.99.1 the guard is `matches!(should_emit, ShouldEmit::Nothing) || matches!(expr.kind, ExprKind::Err(_))`; I removed the `ShouldEmit::Nothing` part, so with Nothing (early/silent parsing, e.g. `#[deprecated = concat!()]`) the error is built and reaches the emit path (delay_as_bug) -> ICE again.
