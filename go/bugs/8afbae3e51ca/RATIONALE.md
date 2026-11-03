# Rationale

go1.27.3 still contains the fix (`findIndVar` in src/cmd/compile/internal/ssa/loopbce.go), so I restored the pre-fix restrictions there. The other fix hunks are comments or a refactor of the downward-counting rewrite, so I left them alone.

Hunks reversed, both in `findIndVar`:
- The fix replaced `b.Kind != BlockIf || len(b.Preds) != 2` with `b.Kind != BlockIf`. I restored the `len(b.Preds) != 2` check, so the comparison block must itself have two predecessors.
- The fix replaced `if ind.Block != b { continue }` with `if len(ind.Block.Preds) != 2 { continue }`. I restored the `ind.Block != b` check, so the induction variable's phi must live in the comparison block.

Together these allow only one induction variable per header block. A second comparison, such as `j >= 0` in `idxA >= 0 && idxB >= 0`, sits in a different block from the phi and is no longer recognised.

Oracle: `Test/prove.go` fails with `prove.go:2506: missing error "Proved IsInBounds$"`. That line is in `issue76269`, the test the fix added. The bounds check on `b[idxB]` is no longer proved. This is a missed optimization, which is what #76269 reported. The generated code stays correct.
