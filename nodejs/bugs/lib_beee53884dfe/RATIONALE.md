# Re-introduced bug
WebIDL `object`/dictionary conversion: `validateObject` rejects arrays and functions even when the caller opts in via allowArray/allowFunction, so dictionary args that may be functions/arrays (Event options, addEventListener options, deriveKey algorithm) are wrongly rejected.

## Hunk
lib/internal/validators.js: corresponds to the fix's validators.js hunk (adding allowArray/allowFunction). In today's code these are the flags kValidateObjectAllowArray/kValidateObjectAllowFunction; I made `throwOnArray` and `throwOnFunction` always true, so the flags are ignored, as before the fix. The event_target.js/webcrypto.js hunks of the fix need no change (the call-site opt-ins remain but have no effect).

## Failing test
parallel/test-validators: `validateObject([], 'foo', kValidateObjectAllowArray)` throws ERR_INVALID_ARG_TYPE. test-eventtarget still passes.
