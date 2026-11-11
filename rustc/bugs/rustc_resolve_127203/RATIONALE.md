# Adapted injection for Fix import suggestion error when failed not from starting

Fix: https://github.com/rust-lang/rust/commit/8cc1ed81dfd9e6eeb50d3621e0c862e9d3b4fe92

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs (the "cannot find `x` in the crate root" suggestion code; moved from diagnostics.rs).

Fix hunk `@@ -1987,10 +1987,20 @@` added a block that strips the common prefix of the candidate path
(`// remove the possible common prefix of the path`, `start_index ... find(...)`) and suggested
`pprust::path_to_string(&path)` instead of `path_to_string(&candidate.path)`.
In 1.99.1 the equivalent block is `let path = { ... start_index ... }`; I replaced it with
`let path = candidate.path.clone();`, restoring the pre-fix behaviour of suggesting the full candidate path.
