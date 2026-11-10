# Adapted injection for Fix cycle error only occurring with -Zdump-mir

Fix: https://github.com/rust-lang/rust/commit/15c01eb22c8f7abbfe6d49dc5824c239547a0323

# Rationale
File: compiler/rustc_middle/src/mir/pretty.rs, fn `write_allocations`, arm `Some(GlobalAlloc::Static(did)) if !tcx.is_foreign_item(did)`.
Re-expresses the fix hunk `@@ -1555,16 +1555,22 @@ pub fn write_allocations`, which added
`if body.phase <= MirPhase::Runtime(RuntimePhase::PostCleanup) && ...body_const_context(...).is_some() { write!(w, ")") } else { eval_static_initializer ... }`.
I removed that guard so the static initializer is always evaluated when dumping MIR (the pre-fix behaviour), which causes cycle errors with -Zdump-mir for cyclic statics.
