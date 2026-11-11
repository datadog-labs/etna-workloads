# Adapted injection for Forbid object lifetime changing pointer casts

Fix: https://github.com/rust-lang/rust/commit/85aeb4f2593f120ccde53f5855676eaa9739734f

# Rationale
Only file changed: compiler/rustc_borrowck/src/type_check/mod.rs, `visit_rvalue`, `CastKind::PtrToPtr` dyn-tail branch (the last hunk of fix, `@@ -1491,55 +1524,90 @@`).

1. `src_obj` is built with `dst_lt` again instead of `src_lt` (fix removed
   `// FIXME: Once we disallow casting ... dst_lt,` and used `src_lt`). So the dyn lifetime bound of the source is ignored, allowing lifetime-extending casts (#136702).
2. The `(None, None)` principalless arm, which pushed an `OutlivesConstraint { sup: src_lt, sub: dst_lt, category: Cast{is_raw_ptr_dyn_type_cast: true..}}` (fix added "You can only cast `dyn Send + 'long` to `dyn Send + 'short`"), is made a no-op, as before the fix (old code only handled the principal-on-both-sides case).
The ConstraintCategory field/diagnostic hunks are left in place (they're plumbing and harmless).
