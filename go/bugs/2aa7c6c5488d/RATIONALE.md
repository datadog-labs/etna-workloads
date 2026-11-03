# Rationale

Fix: forbid NaNs as SSA floating-point constants. In go1.27.3 this lives in
`src/cmd/compile/internal/ssa/_gen/generic.rules` (plus generated `rewritegeneric.go`)
as NaN-avoidance guards on constant folding. I removed those guards:

- `Mul32F/Mul64F` const-const: dropped `&& c*d == c*d` (fix: `!math.IsNaN(c*d)`).
- `Div32F/Div64F` const-const: dropped `&& c/d == c/d` (fix: `!math.IsNaN(c/d)`).
- `Sqrt (Const64F)`: dropped `&& !math.IsNaN(math.Sqrt(c))`.
- `Load` of `Store (Const64/Const32)` for float types: dropped the `!math.IsNaN(...)` guards
  (the Float{32,64}frombits constant passthrough).

`rewritegeneric.go` was regenerated with `go run .` in `_gen`. The check.go NaN assertions
and arch-specific rules (PPC64 FSQRT, Wasm) were left as is; they are not needed to restore the bug.

## Oracle
`test/codegen/math.go` fails: `nanGenerate64/32` expect DIVSD/DIVSS/SQRTSD/MULSD to be emitted,
but 0/0, 0*inf and sqrt(-1) are now constant-folded into NaN constants, so those opcodes are missing.
