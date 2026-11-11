# Adapted injection for fix where clause rustfix suggestion spacing

Fix: https://github.com/rust-lang/rust/commit/785b5113608a886309962ed836ee7a4bcf13bfaa

Hunk: compiler/rustc_ast_passes/src/ast_validation.rs, in the item visitor's deprecated-where-clause-location lint (visit_item, AssocTy case).
`left_sp` is the span of the misplaced `where` clause that the MoveToEnd suggestion deletes. Reverted to `let left_sp = err.span;`, removing the `span_extend_prev_while(err.span, char::is_whitespace)` extension.
Re-expresses fix hunk `@@ -1832,7 +1834,11 @@` (`let left_sp = self.sess.source_map().span_extend_prev_while(...)` replacing `let err.span`).
The leading whitespace is no longer removed, so the rustfix output has a double space (`type Assoc  = ...`).
The fix's other hunks (needs_comma and the RemoveWhere span) were already in place in 1.99.1 and were left alone.
