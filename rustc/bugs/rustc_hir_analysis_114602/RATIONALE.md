# Adapted injection for Stop using identity args for opaque type wf checks and instead load the args from the single use of a RPIT in its parent function's return type

Fix: https://github.com/rust-lang/rust/commit/67703b9161e4869c5ac155e9a12317c1a2fee339

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs, fn `check_opaque_meets_bounds`.
In 1.99.1 the RPIT/async-fn-return hidden-type sanity check is skipped via a HACK branch
(`else if let FnReturn|AsyncFn = origin { let _ = infcx.take_opaque_types(); Ok(()) }`), because the
RPIT-args lookup (`FindOpaqueTypeArgs`/`find_and_apply_rpit_args`) was removed. I deleted that branch so
RPITs go through `sanity_check_found_hidden_type` again, comparing `type_of(key.def_id).instantiate(key.args)`
using identity-derived args with no RPIT-use args from the parent fn signature. This re-expresses the fix hunk
`@@ -407,7 +407,38 @@ fn check_opaque_meets_bounds` (removal of identity args use, replaced by
`FindOpaqueTypeArgs` args from the fn return type) and `@@ -468,9 +499,10 @@` (sanity check over taken opaque types):
the pre-fix behaviour used identity args for RPIT wf checks, spuriously rejecting valid code.
