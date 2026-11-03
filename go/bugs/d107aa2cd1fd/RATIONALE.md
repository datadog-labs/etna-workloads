# Rationale

Fix (#50193): generic instantiations can convert a constant int/float to a
complex type, e.g. `T(0)` or `T(3.14)` with `T` constrained by complex types.
The fix added to `ssagen.(*state).conv` a branch for `tt.IsComplex()` with a
non-complex `ft`. It builds `ComplexMake(conv(v), 0)`.

## Changes

1. `src/cmd/compile/internal/ssagen/ssa.go`: removed the
   `if tt.IsComplex() { // and ft is not complex ... }` block from `conv`.
   This reverses the fix hunk that added it. The complex->complex block
   was only moved by the fix and is left in place, since its position is not
   behaviour.

2. `src/cmd/compile/internal/noder/reader.go` (`exprConvert`): removed the
   `dstTypeParam && ir.IsConstNode(x)` branch. That branch folds the constant into a
   typed literal at instantiation time, wrapped in OCONVNOP. The fix message
   names exactly this alternative ("We could [convert] constant literals
   during instantiation"). In go1.27.3 it covers the same case from the
   frontend, so reverting only (1) made no oracle case fail. `dstTypeParam`
   is still read from the export data (`_ = r.Bool()`) to keep the
   stream in sync.

## Oracle result

`test/typeparam/issue50193.go` fails to compile:
`internal compiler error: 'pi[complex128]': weird float conversion float64 -> go.shape.complex128`
This is the pre-fix failure: SSA gets an OCONV from a constant float to a complex type and has no handling for it.
