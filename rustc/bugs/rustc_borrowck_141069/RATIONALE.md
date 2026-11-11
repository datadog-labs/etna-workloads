# Adapted injection for Suggest mut when possbile for temporary value dropped while borrowed

Fix: https://github.com/rust-lang/rust/commit/d5d4cecee9a3456ec0ec6011090c947fe5409995

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, `report_temporary_value_does_not_live_long_enough`.
Removed the `mutability` computation (`matches!(borrow.kind(), BorrowKind::Mut{..})` -> "mut ") and went back to
`format!("let binding = {};\n{}", s, " ".repeat(p))`. Re-expresses the fix hunk `@@ -3229,8 +3229,20 @@` which added
`let mutability = ...` and `"let {}binding = ..."`. Bug: the suggested `let binding` lacks `mut` for `&mut` borrows.
