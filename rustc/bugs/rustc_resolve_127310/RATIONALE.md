# Adapted injection for Fix import suggestion ice

Fix: https://github.com/rust-lang/rust/commit/fe5581dd31eb1b86c915e5c3eaae9ebfdea28037

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, fn report_path_resolution_error (1.99.1 location of the fix's code).
Re-expresses the single hunk `@@ -1989,12 +1989,12 @@` of diagnostics.rs: restored the pre-fix common-prefix computation
(`(0..failed_segment_idx).find(|&i| path[i].ident != candidate.path.segments[i].ident)` and
`(start_index..=failed_segment_idx).map(|s| candidate.path.segments[s]...)`) instead of the bounded `len` version,
so indexing candidate.path.segments[failed_segment_idx] can go out of bounds (ICE).
