# Rationale

Fix (golang/go#40426) added the FP load+op indexed ops (ADDSSloadidx1 etc.) to the
addressing-modes pass. In go1.27.3 the ops, the amd64/ssa.go codegen cases and opGen
already exist; the only thing that makes them reachable is the `combine` table.

Changed: `src/cmd/compile/internal/ssa/addressingmodes.go` — removed the 16
`{ADD,SUB,MUL,DIV}{SS,SD}load` + `LEAQ1/4/8` entries in `combine`. This reverses the
fix's addressingmodes.go hunk exactly. The pass then never fuses FP load+op with an
indexed address (the pre-fix missed optimization); the other hunks (ops, codegen) are
left in place since they are inert without the table entries.

Oracle: `test/codegen/memops.go` (Test, Test/codegen/memops.go) fails: asmcheck lines
for idxFloatOps (ADDSD/SUBSD/MULSD/DIVSD/ADDSS/SUBSS/MULSS/DIVSS with indexed operand)
report "opcode not found".
