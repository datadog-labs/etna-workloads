# Adapted injection for Add discriminators to DILocations when multiple functions are inlined into a single point.

Fix: https://github.com/rust-lang/rust/commit/1dc106121b62562ead6e7d612fa136dc4b35cd5d

# Rationale
File: compiler/rustc_codegen_ssa/src/mir/debuginfo.rs, `make_mir_scope` (the logic moved here from rustc_codegen_llvm's create_scope_map.rs).
Removed the `match discriminators.entry(callsite_span.lo()) { Occupied => clone loc with discriminator, Vacant => insert }` and always return `loc`.
Re-expresses the fix hunk `@@ -117,7 +141,37 @@ fn make_mir_scope` in create_scope_map.rs, which replaced
`cx.dbg_loc(callsite_scope, parent_scope.inlined_at, callsite_span)` with the loc + discriminator match
(`LLVMRustDILocationCloneWithBaseDiscriminator`). Without it, multiple inlines at one span get identical DILocations.
The `discriminators` map is left threaded through (`let _ = &discriminators;`) to keep the build clean.
