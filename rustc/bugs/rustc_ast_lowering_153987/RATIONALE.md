# Adapted injection for mGCA: Lower const generic args to infer when needed

Fix: https://github.com/rust-lang/rust/commit/924374c75b6ec99c5d95847f6c54554d8d590716

# Hunk: compiler/rustc_ast_lowering/src/lib.rs, `lower_generic_arg`, `ast::GenericArg::Const` arm
Fix hunk `@@ -1269,9 +1269,13 @@` replaced `GenericArg::Const(self.lower_anon_const_to_const_arg_and_alloc(ct).try_as_ambig_ct().unwrap())`
with a match that lowers non-ambig (Infer) const args to `GenericArg::Infer`. Reverted to the unwrap form (on 1.99.1 the Infer variant is an arena-allocated InferArg with kind Const), so `{_}` panics on unwrap.
