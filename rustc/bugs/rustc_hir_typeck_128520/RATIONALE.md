# Adapted injection for Skip over args when determining if coroutine-closure's inner coroutine consumes its upvars

Fix: https://github.com/rust-lang/rust/commit/5138586678fa3186118e5e3eaaf623759d839bb7

# Rationale
File: compiler/rustc_hir_typeck/src/upvar.rs, fn `coroutine_body_consumes_upvars`.
Re-expresses fix hunk `@@ -535,6 +528,53 @@` (the new fn, which skips the arg-capturing Block and the DropTemps to analyse only the "real" body). The buggy version no longer skips them: it runs consume_expr on the whole `body.value`, including the by-move argument captures, so a non-copy argument makes the inner coroutine look FnOnce and forces it to `move`.
