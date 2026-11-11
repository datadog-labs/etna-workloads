# Adapted injection for Always use `ConstFn` context for `const` closures

Fix: https://github.com/rust-lang/rust/commit/0e72a29c934c2d2ece2990c32b9bdc161a7b5161

# Rationale
File `compiler/rustc_middle/src/hir/map.rs`, fn `hir_body_const_context`.
Fix hunk `@@ -317,11 +317,9 @@` replaced a separate arm
`BodyOwnerKind::Closure if self.is_const_fn(def_id) => return self.hir_body_const_context(self.local_parent(..))`
("Const closures use their parent's const context") with a merged `Fn | Closure` arm giving `ConstFn`.
In 1.99.1 the merged arm already exists (plus an `always: true` check), so I re-split it: closures that are const fn
return the parent's const context again; `Fn` keeps the existing logic.
