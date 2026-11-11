# Adapted injection for Fix unwrap error in overflowing int literal

Fix: https://github.com/rust-lang/rust/commit/ace6bb9869747b50d7d4bfaacc65d0592ec94aef

# Rationale
compiler/rustc_lint/src/types.rs, `TypeLimits::check_lit`: the pattern-negation flag (`is_negated_pat`, successor of the fix's `negated` argument) is ignored (`if false && is_negated_pat`), so only the expression-level `last_visited_negation` marks a literal as negated.
Re-expresses fix hunks `@@ -245,12 +245,11 @@ fn lint_int_literal` in literal.rs (`-    negated: bool`, `-    let negative = negated ^ (...)` -> `let negative = type_limits.negated_expr_id == Some(hir_id)`) and the types.rs hunk (`if negated { self.negated_expr_id = ... }`). Negated literal patterns such as `if let -129 = 0i8` are treated as non-negated, so the lint output is wrong.
