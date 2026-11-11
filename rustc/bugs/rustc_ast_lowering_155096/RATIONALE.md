# Adapted injection for Support proper interaction of user-specified args and impl Traits

Fix: https://github.com/rust-lang/rust/commit/51888a15fb80a98ee2966ac59bb6b05585762dc6

# Rationale
One hunk: compiler/rustc_ast_lowering/src/delegation/generics.rs, `DelegationGenerics::new`-style fn building `child_generics` when `res.child_args` is Some (user-specified child args).
The fix hunk (`@@ -257,22 +251,28 @@`, in the old layout):
```
         let child_generics = if child_user_specified {
+            let synth_params_index =
+                sig_params.iter().position(|p| p.kind.is_synthetic()).unwrap_or(sig_params.len());
+            DelegationGenerics::user_specified(&sig_params[synth_params_index..])
```
made synthetic (`impl Trait`) params still be generated when the user gave explicit args. On 1.99.1 this became the `synth_params_index` split plus pushing `GenericArgSlot::Generate(synth_param, None)` for the synthetic tail. I removed the split and the loop, passing all `sig_child_params` to `create_slots_from_args`, so synthetic params are no longer generated (the old buggy behaviour).
Other fix hunks (delegation.rs, hir_ty_lowering, generics.rs own_synthetic_params_count) are left intact.
