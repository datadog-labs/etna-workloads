# Adapted injection for fixes #114896

Fix: https://github.com/rust-lang/rust/commit/a8f3c7684df5ac15c770ef92d58436aa3386cfcf

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, fn report_mutability_error.

Hunk 1 (re-expressed, reversed): fix hunk `@@ -370,12 +370,7 @@` replaced the plain
`err.span_suggestion_verbose(local_decl.source_info.span.shrink_to_lo(), "consider changing this to be mutable", "mut ", ...)`
with `self.construct_mut_suggestion_for_local_binding_patterns(&mut err, local);`.
I restored the plain `mut ` suggestion at the call site, so `let &b = a;` gets `let &mut b = a;` (type error) instead of `let &(mut b) = a;`.
The helper (fix hunk 2, `@@ -710,6 +705,83 @@`) is left in place but marked `#[allow(dead_code)]` since it is now unused (it is the part of the fix that was added; the parent had no such function).
