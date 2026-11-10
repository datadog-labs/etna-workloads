# Bug
`vm.compileFunction` validated `options.lineOffset` / `options.columnOffset` as uint32, so negative offsets (valid int32 values) threw `ERR_OUT_OF_RANGE`.

# Change
In this release `compileFunction` lives in `lib/vm.js` (not `lib/internal/vm.js`). Hunk: lines ~339-340 changed `validateInt32` -> `validateUint32` for columnOffset and lineOffset. This corresponds to the fix's hunk replacing `validateUint32` with `validateInt32` in `internalCompileFunction`; `validateUint32` was already imported in lib/vm.js. (The import hunk of the fix needs no counterpart.)

# Failing test
es-module/test-vm-compile-function-lineoffset:
`RangeError [ERR_OUT_OF_RANGE]: The value of "options.columnOffset" is out of range. It must be >= 0 && <= 4294967295. Received -2147483648`
