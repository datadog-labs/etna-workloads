# Adapted injection for Don't do coroutine-closure-specific upvar analysis if tainted by errors

Fix: https://github.com/rust-lang/rust/commit/49e73c3e0194336c5eee8229afe9ffa79daa2c4f

# Rationale
File: compiler/rustc_hir_typeck/src/upvar.rs, fn `closure_analyze`/`analyze_closure` (coroutine-closure block).
Re-expresses fix hunk `@@ -361,7 +363,9 @@` : `if let UpvarArgs::CoroutineClosure(args) = args && !args.references_error()`.
In 1.99.1 the guard had been rewritten as an `if let Some(guar) = args.error_reported().err() {demand_eqtype(.. error)} else {...}` branch;
I removed the error branch so the coroutine-closure-specific upvar analysis always runs even when tainted by errors (the old behaviour -> ICE).
The other fix hunks (resolve_vars_if_possible, derive TypeVisitable on UpvarArgs) are already present and are not needed to reintroduce the bug.
