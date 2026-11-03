# Rationale

Fix (#74485): unsigned div-by-power-of-two rules used the signed `isPowerOfTwo(c)`
(requires `c > 0`), so constants with the top bit set (e.g. `b/128` for uint8,
`b/1<<31` for uint32) were not strength-reduced to shifts. The fix added unsigned checks.

In go1.27.3 `isPowerOfTwo` is generic and `log8..log64` wrap `log*u`, so the
rules were switched to unsigned casts. Changes:

- `_gen/generic.rules` (Div8u/16u/32u/64u): reverted to `isPowerOfTwo(c)` with the
  signed-typed `c` and `log8/16/32/64(c)`, reversing the fix's rule hunk. Also
  restored the `(Div64u n (Const64 [-1<<63]))` special case the fix removed.
- `rewritegeneric.go`: regenerated with `go run *.go` in `_gen` (matches rewrite hunks).

Failing oracle: `Test` / `Test/codegen/issue74485.go` — on amd64, `uint32/2147483648`,
`uint16/32768`, `uint8/128` compile to DIV instead of SHR (missing `SHRL $31`, `SHRW $15`,
`SHRB $7`). The uint64 case still passes thanks to the restored special rule.
