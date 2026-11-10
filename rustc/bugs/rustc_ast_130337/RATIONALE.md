# Adapted injection for Handle macro calls in anon const def creation take 2

Fix: https://github.com/rust-lang/rust/commit/781ec111b728a4d1ae513ae57d5eecf27680a216

# Rationale
One hunk: compiler/rustc_ast/src/ast.rs, `Expr::maybe_unwrap_block`.
It now recurses (`expr.maybe_unwrap_block()`), so all nested braces are stripped instead of exactly one.

Re-expresses fix.diff hunks in ast.rs (`@@ -1187,8 +1187,8 @@ is_potential_trivial_const_arg(strip_identity_block)` and
`@@ -1199,14 +1199,15 @@ maybe_unwrap_block` - "Returns an expression with (when possible) *one* outter brace removed").
The fix's point is that only ONE brace level may be stripped when judging a const arg as trivial (`{ N }` trivial, `{{ N }}` not).
The 1.99.1 code was refactored (DefCollector no longer delays anon const defs), so the bug is restored at the one-brace-level invariant:
`{{ N }}` / macro expanding to `{ N }` inside braces is wrongly treated as a bare param.
