# Rationale

Bug: ESM `data:` URL loading used a home-grown regex (`DATA_URL_PATTERN`) on `url.pathname` plus `decodeURIComponent`, instead of the WHATWG fetch data-URL processor. Query strings (`?`) were dropped from the body (pathname excludes them), so `data:text/javascript,var x = "hello world?"` was truncated; invalid MIME types raised ERR_INVALID_URL instead of falling back to text/plain; percent-decoding was not spec-compliant.

Change (lib/internal/modules/esm/load.js, single hunk in `getSourceSync`, which now holds the only data: handling since the old async `getSource` was removed):
- Re-adds `decodeURIComponent` to the primordials import and the `DATA_URL_PATTERN` constant (reverse of the fix's import/pattern hunks).
- Replaces the `dataURLProcessor(url)` call with the regex match on `url.pathname` and `BufferFrom(decodeURIComponent(body), base64 ? 'base64' : 'utf8')` (reverse of the fix's getSource/getSourceSync hunks).
`lib/internal/data_url.js` is left in place (unused by load.js), as the fix's new file is not an old-behaviour hunk.

Failing test: es-module/test-esm-data-urls (the `invalid` MIME case now rejects with ERR_INVALID_URL rather than ERR_UNKNOWN_MODULE_FORMAT, and the `?` body case fails). parallel/test-data-url tests the internal module directly and still passes.
