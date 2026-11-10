# Adapted injection for safe transmute: gracefully bubble-up layout errors

Fix: https://github.com/rust-lang/rust/commit/e2328ebd7f37fdfa5059fa8da954d198f6f744f7

# Re-injection: safe transmute layout errors no longer bubble up

1.99.1 already used `layout_of(cx, ty)?` everywhere, so the old behaviour is restored.

## compiler/rustc_transmute/src/layout/tree.rs
- Added back `pub(crate) fn ty_layout(cx, ty) -> Layout { layout_of(cx, ty).unwrap() }`.
  Re-expresses the removed hunk `@@ -484,10 +484,6 @@` (`-pub(crate) fn ty_layout ... .unwrap()`).
- In `Tree::from_ty`, the array/ref arms, the enum/struct field helpers (`from_struct`/`from_union`-like code),
  every `layout_of(cx, X)?` is changed back to `ty_layout(cx, X)`.
  Re-expresses hunks `@@ -206,7`, `-239`, `-254`, `-280`, `-413`, `-471` (`-let layout = ty_layout(cx, ty);` -> `layout_of(cx, ty)?`).

## compiler/rustc_transmute/src/maybe_transmutable/mod.rs, `answer`
- Restored the `layout_of` closure that maps layout failure to `Err::NotYetSupported` and then calls `Tree::from_ty`;
  `src`/`dst` use it again. Re-expresses hunk `@@ -44,18 +44,11 @@`.
