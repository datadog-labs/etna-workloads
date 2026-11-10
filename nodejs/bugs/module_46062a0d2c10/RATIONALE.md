# Re-introduced bug: unhelpful error for invalid data: URLs

**Bug.** Importing a `data:` URL with an unsupported MIME type (e.g. `data:text/plain,...`) produced a generic error with no hint about the MIME type. Before the fix it was `ERR_INVALID_RETURN_PROPERTY_VALUE`. In today's code the equivalent defect is `Unknown module format: null for URL ...`, with no MIME type.

**Hunk (lib/internal/modules/esm/load.js, `throwUnknownModuleFormat`).** This corresponds to the fix's hunk in `Loader` that matches `/^data:(...)/` against the URL when `format === null` and puts the MIME type in the error. In today's code that logic lives in `throwUnknownModuleFormat`. I removed the data-URL regexp and its unused `RegExpPrototypeExec` import. The function now always reports the raw `format` (null), so the MIME type is lost, as it was before the fix.

**Failing test.** `es-module/test-esm-invalid-data-urls` fails, and the result was the same on two runs:
expected message `Unknown module format: text/plain for URL data:text/plain,export default0`, actual `Unknown module format: null for URL data:text/plain,export default0`.
`es-module/test-esm-data-urls` still passes.
