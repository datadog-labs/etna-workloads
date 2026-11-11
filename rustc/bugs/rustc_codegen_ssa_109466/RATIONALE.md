# Adapted injection for Preserve argument indexes when inlining MIR

Fix: https://github.com/rust-lang/rust/commit/a6292676eb412d8239b308cfd1660aa75623bf5b

# Rationale
Only one hunk: compiler/rustc_codegen_ssa/src/mir/debuginfo.rs, in the function that builds `dbg_var` (var_kind computation).
Re-expresses the fix hunk `@@ -442,11 +442,10 @@` in the same file: the fix replaced
`self.mir.local_kind(place.local) == LocalKind::Arg && place.projection.is_empty() && var.source_info.scope == OUTERMOST_SOURCE_SCOPE` + `arg_index = place.local.index() - 1` (+1 later)
with `if let Some(arg_index) = var.argument_index`. I restored the old check (local kind is Arg, outermost scope, arg index derived from the local index), so inlined callee args lose their argument number.
The `argument_index` field and the other plumbing hunks are left in place (now unused by codegen), since the bug is in codegen's use of it.
