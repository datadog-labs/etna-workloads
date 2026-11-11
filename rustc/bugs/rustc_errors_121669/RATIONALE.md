# Adapted injection for Overhaul how stashed diagnostics work, again.

Fix: https://github.com/rust-lang/rust/commit/260ae701405f1278202de219bcdd0d60e8060da9

# Rationale
File compiler/rustc_errors/src/lib.rs, `DiagCtxtInner::has_errors` and `has_errors_excluding_lint_errors`: removed the lookup of stashed error guarantees (the `.or_else` over `stashed_diagnostics`), so stashed errors are no longer counted as emitted errors and callers must account for them separately again.
This re-expresses the fix's central change: "Stashed errors (not warnings) are counted immediately as emitted errors, avoiding the possibility of forgetting to consider them", and "Calls to the `stashed_err_count` method are no longer necessary alongside calls to `has_errors`" (the has_errors / stashed-guarantee hunks in lib.rs, around old line 1347-1407).
