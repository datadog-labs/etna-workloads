# Rationale

Bug: for ambiguous module syntax (CJS global such as require/exports/__filename/__dirname plus top-level await), the error message was a fixed text mentioning only `require()` and advising "replace require() with import", regardless of which global triggered it.

Change (lib/internal/modules/esm/module_job.js, `explainCommonJSGlobalLikeNotDefinedError`): corresponds to the fix's hunk that introduced the per-global `switch` advice and `'${notDefinedGlobalLike}'` in the message. I removed the `advice` switch and restored the fixed old message ("both require() and top-level await are present ... replace require() with import."). The `ArrayPrototypeFind` rename hunk is left intact (it is behaviour-neutral for the truthiness check).

Failing: es-module/test-esm-detect-ambiguous — assertions expecting `both 'require' and top-level await` (and the exports/__filename/__dirname variants) fail to match stderr.
