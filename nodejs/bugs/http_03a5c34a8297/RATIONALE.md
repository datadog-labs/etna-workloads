# Bug: unbounded HTTP chunk extension size (CVE-2024-22019)

## Description

Node's HTTP parser (built on llhttp) parses "chunk extensions" — the optional
`;key=value` segments that may follow a chunk size in a chunked-encoding
request body. Before the upstream fix, the parser did not bound how many
bytes of chunk-extension data it would accept for a single chunk. A
malicious or buggy client could send a chunk header such as
`2;AAAA...(unbounded)...=bar\r\n` and the server would keep buffering/parsing
extension bytes indefinitely, tying up a connection and consuming memory
with no limit, before any header-size or request-size guard would apply.
The upstream fix added an explicit running counter of chunk-extension bytes
(`chunk_extensions_nread_`), capped it at `kMaxChunkExtensionsSize` (16384
bytes), and had the parser abort the request with a `HPE_CHUNK_EXTENSIONS_OVERFLOW`
error (surfaced to JS as an HTTP 413 response) once the cap was exceeded.

## Change made

Only `src/node_http_parser.cc` was touched, in the static `llhttp_settings_t`
table built from the `Proxy<...>::Raw` callback bindings:

```c
// on_chunk_extension_name
nullptr,
// on_chunk_extension_value
nullptr,
```

This reverts the hunk of the fix that changed these two entries from `nullptr`
to `Proxy<DataCall, &Parser::on_chunk_extension>::Raw`. That hunk is what wired
llhttp's chunk-extension-name/value callbacks to `Parser::on_chunk_extension`,
which is the function that increments `chunk_extensions_nread_` and enforces
`kMaxChunkExtensionsSize`. With the callbacks set back to `nullptr`, llhttp
simply skips over chunk-extension bytes without invoking any Node-side
callback, so `chunk_extensions_nread_` is never incremented and the size
check in `on_chunk_extension` is never reached — reproducing the original
unbounded behaviour.

The rest of the fix's implementation (the `kMaxChunkExtensionsSize` constant,
the `chunk_extensions_nread_` member and its reset in `Parse()`/`on_chunk_header()`,
the `on_chunk_extension` method itself, and the `HPE_CHUNK_EXTENSIONS_OVERFLOW`
→ 413 mapping in `lib/_http_server.js`) was left in place. Those pieces are
harmless but inert once the callbacks are disabled — nothing ever calls
`on_chunk_extension`, so the counter stays at its reset value of 0 for the
whole request and the overflow branch can never be taken. This keeps the
diff to the single hunk that actually matters (disconnecting the enforcement
point), which mirrors, for today's code, the fix's final and decisive hunk
(the settings-table rewiring), without having to hand-revert the now
intertwined counter/constant plumbing that surrounding code still legitimately
depends on existing.

## Hunk correspondence to the fix

| My change | Corresponding fix hunk | Why it restores old behaviour |
|---|---|---|
| `on_chunk_extension_name` / `on_chunk_extension_value` entries set to `nullptr` in the `llhttp_settings_t` table | `src/node_http_parser.cc`: `-    nullptr, ... -    nullptr, ... +    Proxy<DataCall, &Parser::on_chunk_extension>::Raw, ... +    Proxy<DataCall, &Parser::on_chunk_extension>::Raw,` | This is the exact hunk that connected llhttp's extension parsing events to Node's size-tracking callback. Reverting it to `nullptr` means extension bytes are parsed by llhttp but never reported to `Parser::on_chunk_extension`, so no size accounting or enforcement ever happens — identical to pre-fix behaviour. |

No other hunks were reverted (the constant, the counter field, the
`on_chunk_extension` method, the `on_chunk_header` reset, and the
`lib/_http_server.js` error-code mapping were all left untouched), because
leaving them in place but disconnected is sufficient to reproduce the bug
and keeps the change minimal; removing them would be extra churn with no
behavioural effect.

## Test results

Build: `make -j8` completed successfully (incremental rebuild of
`node_http_parser.cc`).

Oracle test run twice against the rebuilt debug binary:

```
python3 tools/test.py -p tap -j 4 --shell out/Release/node \
  --temp-dir <scratch> \
  parallel/test-http-chunk-extensions-limit
```

Result (both runs, stable):

```
not ok 1 parallel/test-http-chunk-extensions-limit
```

The test fails because the server no longer responds with
`HTTP/1.1 413 Payload Too Large\r\nConnection: close\r\n\r\n` when sent an
oversized chunk extension (whether sent all at once or dribbled in over an
interval); instead the connection proceeds to process the chunk normally (or
hangs/times out waiting for more data), so the `assert.strictEqual` checks in
the test against the expected 413 response body fail.
