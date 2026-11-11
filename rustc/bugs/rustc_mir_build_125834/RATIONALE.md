# Adapted injection for compiler: treat `&raw (const|mut) UNSAFE_STATIC` implied deref as safe

Fix: https://github.com/rust-lang/rust/commit/3fdd8d5ef3a8b26c3e24d9baf706fc7fb16717f9

# Rationale
File compiler/rustc_mir_build/src/check_unsafety.rs, `visit_expr`, arm `ExprKind::RawBorrow`.
Fix hunk `@@ -449,6 +449,24 @@` added an arm short-circuiting `&raw` of `*StaticRef` (implied deref of an unsafe static) as safe.
In 1.99.1 that logic is generalized (any `&raw *place` is safe). I re-expressed the bug by excluding the
`ExprKind::StaticRef` case (`&& !matches!(self.thir[arg].kind, ExprKind::StaticRef { .. })`), so `&raw (const|mut) STATIC_MUT/extern static` again falls through to the `Deref` arm and requires unsafe.
The expr.rs hunk was comment-only; not changed.
