# Adapted injection for borrowck: suggest borrowing for destructuring moves from overloaded deref

Fix: https://github.com/rust-lang/rust/commit/7d680171f0a8825029e642a1d06b5a5180423f8d

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/move_errors.rs

- `add_borrow_suggestions`: fix hunk `@@ -787,29 +787,67 @@` added the `is_destructuring_pattern_move` param, `is_ref`/`is_destructuring_assignment`/`is_nested_deref` detection, and the branches ("consider borrowing here" / "destructuring assignment cannot borrow ..."). Restored the old body: only `if !is_raw_ptr { suggest "consider removing the dereference here" }`, so destructuring moves out of overloaded deref get the wrong suggestion.
- Callers in `add_move_hints`-equivalent (two call sites): fix hunk `@@ -678,7 +678,7 @@` passed `!binds_to.is_empty()`; reverted to the 2-arg call.
