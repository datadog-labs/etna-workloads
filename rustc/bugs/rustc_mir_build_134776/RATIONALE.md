# Adapted injection for Account for `for<'a>` types when checking for non-structural type in constant as pattern

Fix: https://github.com/rust-lang/rust/commit/05c39438e295389e30a580a5376bbed83b1ddfa1

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/const_to_pat.rs, fn extend_type_not_partial_eq (UsedParamsNeedInstantiationVisitor::visit_ty).
Fix hunks (@@ -387 / @@ -468 `if ty.has_escaping_bound_vars() { return (false,false,false,None); }` in type_has_partial_eq_impl) added a guard so ADTs with escaping bound vars are not checked for PartialEq.
In 1.99.1 that guard was superseded by `ty::Dynamic(..) => return ControlFlow::Break(())` in the visitor, which stops walking into dyn types (where escaping bound vars appear). I removed that arm, restoring the old behaviour: the visitor walks into `dyn for<'a> Fn(Box<dyn Fn(&'a u8)>)` and builds a PartialEq obligation for a type with escaping bound vars -> ICE (predicate.rs:490).
