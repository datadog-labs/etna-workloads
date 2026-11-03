# Rationale

All changes are in src/cmd/compile/internal/ssa/memcombine.go; they restore the
pre-fix `*8` shift arithmetic (ignoring element size) that the fix replaced.

- combineLoads, big-endian final shift: `shift0-(n-1)*size*8` -> `shift0-(n-1)*8`
  (fix hunk 1). Wrong shift for >1-byte elements on big-endian targets.
- combineStores, little/big-endian detection: today's code uses
  `(a[i].offset-a[0].offset)*8` and a cumulative `shiftedSize*8`; reverted to
  `i*8` (fix hunks 2/3), so stores of 16/32-bit elements are no longer
  recognised and are not combined.
- combineStores, big-endian final shift: today's `aTotalSize-a[0].size`
  reverted to `len(a)-1` (fix hunk 4), i.e. `(n-1)*8`.

## Failing oracle
test/codegen/memcombine.go (store32le/store16le/store32be/store16be): on
amd64 the two uint32/uint16 stores are no longer combined into one MOVQ/MOVL
(opcode not found MOVQ, wrong opcode MOVL/SHRQ). The big-endian miscompile in
TestIssue64468 only manifests on big-endian targets, so it does not fail on amd64.
