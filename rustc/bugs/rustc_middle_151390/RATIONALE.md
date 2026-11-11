# Adapted injection for Reintroduce `QueryStackFrame` split.

Fix: https://github.com/rust-lang/rust/commit/0385e26e7d1e6a984954d1daa448471e9ef1051e

# Rationale
1.99.1 has no QueryStackFrame/QueryStackFrameExtra split anymore (frames hold `tagged_key`; descriptions and spans are computed lazily in `TaggedQueryKey::description/default_span`, `compiler/rustc_middle/src/query/plumbing.rs`). Those two functions are the 1.99.1 equivalent of the fix's `create_query_frame_extra`, so both hunks are there.

## Hunk 1: `TaggedQueryKey::default_span` (rustc_middle/src/query/plumbing.rs)
Removed the `if let TaggedQueryKey::def_span(..) = self { return DUMMY_SP }` guard and wrapped the key's `default_span` in `with_reduced_queries!`.
Re-expresses fix hunk `@@ -326,36 +343,49 @@ create_query_frame` (rustc_query_impl/src/plumbing.rs), reversed:
`-    let span = if reduce_queries {` / `-        Some(tcx.with_reduced_queries(|| key.default_span(tcx)))`
(the fix added `kind == dep_graph::dep_kinds::def_span ||` and removed the `with_reduced_queries` wrapper).

## Hunk 2: `TaggedQueryKey::description` (same file)
`with_no_queries!` replaced by `with_no_trimmed_paths!`, so descriptions are produced without the "no queries" guard (reduced queries / forced impl filename line). Related to fix hunk `@@ -159,9 +159,7 @@ with_no_queries` in rustc_middle/src/ty/print/pretty.rs, which restructured the guard macro, and to the removal of eagerly guarded description computation in `create_query_frame`. This is the hunk that makes the oracle tests fail: descriptions now run queries while a cycle is being printed, giving "query cycle when printing cycle detected" ICEs (the fuzz-failure class of #151226/#151358).
