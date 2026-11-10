input.ts declares a function and a function type with an empty optional binding pattern parameter (`{}?: {x: string}`) in ambient/type positions.
Clean: no diagnostics, exit 0. Injected: TS2532 "Object is possibly 'undefined'" is reported on the pattern (exit 2).
