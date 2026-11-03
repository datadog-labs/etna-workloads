# Rationale

Only file changed: `tree/src/cmd/compile/internal/escape/escape.go`, `rewriteWithLiterals`. All three fix hunks are reversed.

1. `assignTemp` takes no `pos` parameter again and uses `pos := n.Pos()`, the position of the expression being replaced. For the variable's declaration `a := 1`, this is the declaration's line. This reverses hunk 1.
2. OMAKESLICE: the replacement is `*r = lit` again, so the literal keeps the position of the original declaration instead of a fresh `BasicLit` at `n.Pos()`. The temp is positioned at `(*r).Pos()`. This reverses hunk 2.
3. OCONVIFACE: `assignTemp(conv.X, ...)` and `NewBasicLit(conv.X.Pos(), ...)` use the operand's position rather than `conv.Pos()`. This reverses hunk 3.

Effect: the temp assignments and literals carry the position of the variable's declaration, so `.debug_line` goes back to that line (e.g. 12, 13, 13, 12, 14). `TestDebugLines_74576` (i74576a/b) is the oracle that fails.
