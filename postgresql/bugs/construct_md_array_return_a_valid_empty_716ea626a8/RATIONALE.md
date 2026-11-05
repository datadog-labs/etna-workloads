# Rationale

## src/backend/utils/adt/arrayfuncs.c, construct_md_array()
Traces to the fix.patch hunk that replaced the `ndims == 0` fast track with
`nelems = ArrayGetNItems(); if (nelems <= 0) return construct_empty_array()`.
In current code only the latter check exists (after ArrayCheckBounds). I removed it, so
zero-size input (ndims <= 0 or any dims[i] == 0) builds a malformed "empty" array
(e.g. ndims=1, dim 0, or ndims=0 with a data header) instead of the canonical 0-D empty array.

The execExprInterp.c hunk (removal of the nelems == 0 shortcut in ExecEvalArrayExpr) is
already absent in this release, so no change was needed there.

## Failing oracle cases
src/test/regress||tsearch
