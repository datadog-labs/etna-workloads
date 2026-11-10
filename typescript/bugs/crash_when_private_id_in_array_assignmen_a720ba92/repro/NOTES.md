Input `[#abc]=` (a private identifier as an array-assignment element, target es2015) is compiled with NODE_ENV=development, which enables the compiler's debug assertions.
Clean: emits `[#abc] =;` plus the parse error TS1109.
Injected: classFields `visitArrayAssignmentElement` has an unconditional `Debug.assertNode(..., isArrayBindingOrAssignmentElement)`, so tsc crashes with a Debug Failure.
