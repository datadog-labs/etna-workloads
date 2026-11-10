# Re-introduced bug: ClientRequest() does not validate `timeout`

**Bug.** `http.request({ timeout: null })` (or any invalid timeout) was not validated in the
`ClientRequest` constructor. The raw value was stored in `this.timeout`, and the validation error
was thrown later and asynchronously, from `socket.setTimeout()` while the agent set up the socket
(with message `The "msecs" argument ...` rather than `"timeout"`).

**Change (lib/_http_client.js, one hunk).** Corresponds to the fix's only implementation hunk.
The fix replaced `this.timeout = options.timeout;` with
`if (options.timeout !== undefined) this.timeout = validateTimerDuration(...)`
(today named `getTimerDuration`). I restored `this.timeout = options.timeout;`, so the
constructor no longer validates.

**Failing test.** `parallel/test-http-client-timeout-option` fails:
`AssertionError: The input did not match the regular expression /The "timeout" argument must be of type number/.
Input: 'TypeError [ERR_INVALID_ARG_TYPE]: The "msecs" argument must be of type number. Received null'`
(thrown from setRequestSocket in _http_agent, not from the constructor's validation).
