# Adapted injection for Suggest ref mut for pattern matching assignment

Fix: https://github.com/rust-lang/rust/commit/be9dbe910265da4f990d9adddb850cb2c72e63de

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn report_illegal_reassignment (the `consider making this binding mutable` suggestion area).

Removed the block `if !from_arg && !is_for_loop && matches!(decl.local_info(), ... opt_match_place: Some((Some(_), _)) ...) { err.span_suggestion_verbose(..., "to modify the original value, take a borrow instead", "ref mut ", ...) }`.
This re-expresses fix hunk `@@ -3726,6 +3725,22 @@` which added the `ref mut {name}` suggestion ("to modify the original value, take a borrow instead") for pattern-bound bindings. (The first hunk was only a blank-line removal; irrelevant.)
