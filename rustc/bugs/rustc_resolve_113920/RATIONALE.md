# Adapted injection for fix(resolve): report unresolved imports firstly

Fix: https://github.com/rust-lang/rust/commit/1b18e2a176bcad8854839b79d2c96cc78f4ffb23

# Rationale
File compiler/rustc_resolve/src/imports.rs, fn `finalize_imports`.
Re-expresses fix hunk `@@ -505,27 +505,34 @@`: the fix removed the `else if is_indeterminate { ...path.contains("::") ... errors.push }` branch from the main loop and moved it after `if !errors.is_empty() { throw...; return; }`, so real unresolved-import errors are reported first.
Bug re-injected: the indeterminate-import handling is back inside the main loop (in the no-error case), and the trailing post-loop block is removed, so indeterminate imports' errors get mixed in with/ahead of the genuine unresolved import error.
(The `.iter()` hunk #1 is just a refactor needed by the move; not relevant in 1.99.1.)
