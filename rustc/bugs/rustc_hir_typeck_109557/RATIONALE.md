# Adapted injection for Move const trait bounds checks to MIR constck

Fix: https://github.com/rust-lang/rust/commit/b17e6680d668d136e643976c4079c7b1cac1b6b4

# Rationale

One hunk: `compiler/rustc_hir_typeck/src/fn_ctxt/_impl.rs`, `FnCtxt::add_required_obligations_with_code`.

Re-expresses the fix hunk `@@ -1416,41 +1416,19 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>` in `_impl.rs`. The fix made typeck stop
checking const predicates on paths: "We are remapping all predicates to non-const since we don't know if we just
want them as function pointers ... actual checking will occur in ... check_consts". Before the fix, typeck checked
`~const` bounds on every path expression.

In 1.99.1 const bounds are separate `const_conditions` and typeck only checks them at call sites
(`enforce_context_effects`). The old behaviour is restored by also registering the callee's `const_conditions` as
host-effect obligations in `add_required_obligations_with_code`. That function runs for path expressions, so a
function item that is only used as a fn pointer now needs its `[const]` bounds to hold.
The fix's other hunks (MIR constck moving the check) have no 1.99.1 counterpart, because the check is
already done in `revalidate_conditional_constness`.
