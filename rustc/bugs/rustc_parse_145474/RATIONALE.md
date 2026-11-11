# Adapted injection for Properly recover from parenthesized use-bounds (precise capturing)

Fix: https://github.com/rust-lang/rust/commit/eb3e0d4c8a5599db0a4624662e5ab59380be8cd2

# Rationale
compiler/rustc_parse/src/parser/ty.rs, `parse_use_bound` (the 1.99.1 successor of `parse_precise_capturing_args`).
Re-expresses fix hunk `@@ -876,7 +877,22 @@ ... parse_precise_capturing_args`, which added
`if let ast::Parens::Yes = parens { self.expect(exp!(CloseParen))?; ... "precise capturing lists may not be parenthesized" ... }`.
I removed that block (now `let _ = parens;`), so `(use<>)` leaves the `)` unconsumed and no recovery diagnostic is emitted, as before the fix.
