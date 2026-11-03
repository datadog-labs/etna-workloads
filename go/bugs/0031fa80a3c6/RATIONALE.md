# Rationale

Fix (CL 232617) made `fixedlit` treat `var_ == blank` specially. In go1.27.3 this lives in
`src/cmd/compile/internal/walk/complit.go` `fixedlit`. Changes reverse both fix hunks:

- Removed `isBlank := var_ == ir.BlankNode` (fix hunk 1).
- Array/slice `splitnode`: removed the `if isBlank { return ir.BlankNode, r }` (fix hunk 2), so it returns `var_[k]` even when `var_` is `_`.
- Struct `splitnode`: `r.Sym().IsBlank() || isBlank` -> `r.Sym().IsBlank()` (fix hunk 3).

Oracle: `test/fixedbugs/issue38905.go` fails to compile with `cannot use _ as value`
(nested literal with side-effecting value, e.g. `1 / x`, recursing into fixedlit with `_`).
