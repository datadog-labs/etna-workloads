# Verbatim injection for Feed HIR for by-move coroutine body def, since the inliner tries to read its attrs

Fix: https://github.com/rust-lang/rust/commit/e2d5033bce2085fb2baaf5e887d11959928def74

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-C1).
