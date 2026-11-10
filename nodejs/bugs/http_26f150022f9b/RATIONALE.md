# Bug
HTTPParser instances returned to the FreeList pool were not fully cleaned: `onIncoming` and `kOnTimeout` were only reset when a new parser was constructed, not in `cleanParser()`, so pooled parsers retained references (req/socket closures) -> memory retention.

# Change (lib/_http_common.js)
- Removed `parser[kOnTimeout] = null;` and `parser.onIncoming = null;` from `cleanParser()` (fix hunk 2) and restored them in the FreeList factory callback (fix hunk 1, reversed), so they are only nulled on fresh parsers.

# Failing test
parallel/test-http-parser-memory-retention: `actual: [Function: bound onParserTimeout], expected: null` (parser[kOnTimeout] not cleared after socket close).
