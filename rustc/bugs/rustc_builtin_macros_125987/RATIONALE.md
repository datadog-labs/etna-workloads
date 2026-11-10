# Adapted injection for When `derive`ing, account for HRTB on `BareFn` fields

Fix: https://github.com/rust-lang/rust/commit/e7ad2da7f134c66779625a09b134b85ed1c7c7a9

compiler/rustc_builtin_macros/src/deriving/generic/mod.rs, `find_type_parameters` -> `Visitor::visit_ty`:
removed the push of `FnPtr` (was `BareFn`) `generic_params` onto `bound_generic_params_stack` and the
matching `truncate(stack_len)` after `walk_ty`. Re-expresses fix hunks `@@ -412,6 +412,15 @@` (added
`if let TyKind::BareFn(..) && !generic_params.is_empty() { stack.extend(...) }`) and `@@ -422,7 +431,8 @@`
(`visit::walk_ty(self, ty);` + `truncate(stack_len)`). Now `for<'a> fn(T::SomeType<'a>)` yields a where clause without `for<'a>`.
