main.ts does `export { default } from "./other"` with importHelpers, noEmitHelpers and esModuleInterop (commonjs).
Clean: emits `const tslib_1 = require("tslib")` and calls `tslib_1.__importDefault(other_1)`.
Injected: omits the tslib import and calls bare `__importDefault(other_1)`.
