# Adapted injection for fix tail calls to `#[track_caller]` functions

Fix: https://github.com/rust-lang/rust/commit/85d1c89e0fe2c9db253c6e4e53a19302584a2dfd

# Rationale
1. compiler/rustc_codegen_ssa/src/mir/block.rs, `codegen_call_terminator`: removed the match arm `_ if kind == CallKind::Tail && instance.def.requires_caller_location(..)` (lint emission plus indirect call via `resolve_for_fn_ptr` + `get_fn_addr`), leaving `_ => (Some(instance), None)`. Re-expresses hunk `@@ -995,14 +996,35 @@` of block.rs. Also dropped the now-unused `TAIL_CALL_TRACK_CALLER` import (hunk 1). The lint declaration in builtin.rs is left in place; it is just never emitted.
2. compiler/rustc_monomorphize/src/collector.rs, `visit_terminator`: removed the `force_indirect_call` HACK; the callee is again collected as a direct call with `visit_fn_use(.., true, ..)`. Re-expresses hunk `@@ -788,7 +788,35 @@`.
