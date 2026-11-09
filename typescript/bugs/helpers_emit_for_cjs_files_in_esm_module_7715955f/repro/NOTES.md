Compiles a `.cts` file with an async function using `--module es2015 --importHelpers --target es2015`.
Clean: the emitted .cjs uses `tslib_1.__awaiter` (helper via `require("tslib")`).
Injected: an ESM-style helper import is chosen for the CJS file, so the output calls bare `__awaiter` while still having `require("tslib")`.
