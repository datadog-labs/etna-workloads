# Adapted injection for Fix nested zero-args delegation ICE

Fix: https://github.com/rust-lang/rust/commit/11a338deb6884f72f3d3558d810e9b025de23167

# Rationale
File: compiler/rustc_ast_lowering/src/delegation/mod.rs, fn `generate_delegation_error`.

Fix hunk: `@@ -432,6 +432,17 @@ ... args.push(arg);` adding
`if param_count == 0 && let Some(block) = block { args.push(this.lower_target_expr(&block)); }`
with the comment "leave this code as opposed to bodies of extern functions, which are completely erased".
In 1.99.1 delegation lowering was refactored: a zero-param single delegation with a body is rejected in
resolution.rs (DelegationBlockSpecifiedWhenNoParams) and lowered by `generate_delegation_error`, which
kept the user's block as the sole call argument (`this.lower_block_expr(block)`). That is the current
equivalent of the fix's hunk. I changed it to `args = &mut []`, so the block is erased again (pre-fix
behaviour): no E0061 "takes 0 arguments but 1 supplied", and nested delegations in the body are never lowered.
