# Bug
Importing an ES module that references CJS-only globals (`require`, `exports`, `module`, `__filename`, `__dirname`) rejected with the bare `X is not defined` ReferenceError. It lacked the hints "in ES module scope", ", you can use import instead", and the ".cjs / type: module" advice.

# Change
`lib/internal/modules/esm/module_job.js`, `ModuleJob.run()`: removed the try/catch around `this.module.evaluate(...)` that called `explainCommonJSGlobalLikeNotDefinedError(e, ...)`. This corresponds to the fix's hunk adding the try/catch in `run()`, which is the pre-fix behaviour (a plain `await evaluate`). The helper functions and the `ModuleJobSync` path are left as they are. The fix's `getPackageScopeConfig` export hunk and the primordials hunks are not reverted, because current code already differs and they are harmless.

# Failing test
`es-module/test-esm-undefined-cjs-global-like-variables` fails with "not ok" (assert.rejects, message does not match `/require is not defined in ES module scope, .../`). It failed on two consecutive runs.
