# Adapted injection for skip incorrect suggestion in nested imports

Fix: https://github.com/rust-lang/rust/commit/a2c0e02be822b593506d19b0ae265fbb083e5d95

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs, fn reporting privacy errors (the `can_replace_use` computation, ~line 2812).
Fix hunk (`@@ -2483,6 +2483,11 @@` in diagnostics.rs, moved to diagnostics/impls.rs in 1.99.1) added
`if single_nested { break; }` before building the path suggestion. In 1.99.1 this is `&& !single_nested` in `can_replace_use`; I removed it, so nested imports (`use a::{One, Two}`) again get a full-path replacement of just the inner ident (invalid code).
