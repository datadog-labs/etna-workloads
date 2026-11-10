# Bug
HTTP/2 server responses overwrite an explicitly set `date` header with the current UTC date.

# Change (lib/internal/http2/core.js, prepareResponseHeadersObject)
Corresponds to the single fix hunk in `processHeaders` (which guarded `headers[date] = utcDate()` with a null/undefined check). In today's code the guard is the `hasDate` flag collected while copying headers; I removed the flag and its collection so `date` is set unconditionally (still subject to `options.sendDate`), as before the fix. The array-headers path was left unchanged, since the original fix didn't touch it.

# Failing test
parallel/test-http2-removed-header-stays-removed:
AssertionError: Expected values to be strictly equal: + actual 'Wed, 04 Nov 2026 11:46:04 GMT' - expected 'snacks o clock'
