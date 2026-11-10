# Re-introduced bug: falsy `cause` omitted by util.inspect

Bug: `util.inspect(err)` only displays `[cause]` when `err.cause` is truthy, so falsy causes (`false`, `null`, `0`, `''`) are silently dropped.

Hunk (lib/internal/util/inspect.js, formatError): the fix changed `if (err.cause && (...))` to `err.cause !== undefined`. In today's code the check is `ObjectPrototypeHasOwnProperty(err, 'cause')`; I prepended `err.cause &&` to it, restoring the truthiness gate so falsy causes are not pushed to `keys`.

Failing test: parallel/test-util-inspect (not ok), e.g. falsy cause test: actual output lacks `[cause]`, expected '[Error] { [cause]: false }'. Failure was stable across two runs.
