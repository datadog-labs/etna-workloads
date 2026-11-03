# Rationale

Fix hunk reversed: the `overflowNames` change that added `OXOR: "bitwise XOR"` and `OBITNOT: "bitwise complement"`.
In go1.27.3 this table is `op2str1` / `op2str2` in `src/cmd/compile/internal/types2/expr.go`, and `opName` feeds the
"constant %soverflow" message in `Checker.overflow` (types2/const.go). I removed the `syntax.Xor` entries from both
tables, so XOR and complement overflow is reported without the operation name.

I did not revert the other two fix hunks (the `origConst` Unknown handling and `nodlit`). types2 has replaced that code path.

Oracle failure: `test/const2.go` fails. Lines 31 and 32 report `constant overflow`, but the test expects
`constant bitwise XOR overflow` and `constant bitwise complement overflow`.
`issue20232.go` still passes.
