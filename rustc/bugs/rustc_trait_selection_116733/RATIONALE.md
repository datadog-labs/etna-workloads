# Adapted injection for Consider static specially

Fix: https://github.com/rust-lang/rust/commit/371d8a8215597dbdb048552d7bc6962d2a95909b

# Rationale
File: compiler/rustc_trait_selection/src/traits/outlives_for_liveness.rs, fn `live_args_for_outlives_clause`.
Changed `ty::ReStatic => Some(FxIndexSet::default())` to `ty::ReStatic => None`, so a `'static` outlives
clause from the param-env (e.g. `T: Foo<borrow(): 'static>`) no longer yields "alias captures no args".

Re-expresses the fix hunk `@@ -653,12 +661,16 @@ ... make_alias_live`: the fix added
`if outlives_bounds.contains(&tcx.lifetimes.re_static) { ControlFlow::Continue(()) }`; before it, `'static` was
not considered specially and the alias was walked. In 1.99.1 that logic lives in this function (the item-bound
variant in `live_args_for_alias_from_outlives_bounds` is left intact).
