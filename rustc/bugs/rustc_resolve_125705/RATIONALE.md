# Adapted injection for Reintroduce name resolution check for trying to access locals from an inline const

Fix: https://github.com/rust-lang/rust/commit/bcfefe1c7e8de6c7b3ee79d402bb107303934e63

# Rationale
File: compiler/rustc_resolve/src/late.rs, `resolve_expr`.
Fix hunk `@@ -4502,6 +4502,11 @@` added an `ExprKind::ConstBlock` arm in `resolve_expr` that resolves the
inline const body under an `AnonConstKind::InlineConst` constant rib. In 1.99.1 that arm is
`ExprKind::ConstBlock(ref ct) => self.resolve_anon_const(ct, AnonConstKind::InlineConst)`.
I removed it, so inline const blocks fall through to the default walk and get no constant rib.
Locals from the enclosing fn are then no longer rejected with E0435.
