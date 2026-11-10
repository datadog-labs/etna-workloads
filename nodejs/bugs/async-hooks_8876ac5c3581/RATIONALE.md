# Re-introduced bug (nodejs/node 8876ac5c: async_hooks: fixup do not reuse HTTPParser)

**Bug:** The HTTPParser's async-hooks identity was fixed at construction time (`new HTTPParser(type)`
called `AsyncWrap(..., PROVIDER_*)`), so `init` fired once at allocation, with the parser itself as the
resource. Reused (pooled) parsers never emit a fresh `init` on `initialize()`, the resource is the
HTTPParser, and the type is chosen by the parser's construction type (client parsers from the pool
are labelled HTTPINCOMINGMESSAGE/REQUEST type). Tests that construct `new HTTPParser()` without a type fail.

## Hunks
- `src/node_http_parser.cc` Parser ctor: takes `llhttp_type_t` and passes the provider to
  `AsyncWrap` (reverses the fix's `Parser(env, wrap)` / `AsyncWrap(env, wrap)` change, which made
  the reusable-instance constructor used). `Parser::New` again CHECKs an Int32 type arg (reverse of fix's New hunk).
- `src/node_http_parser.cc` `Initialize`: removed `parser->AsyncReset(args[1].As<Object>())`
  (reverse of the fix's added line), so no init is emitted on (re)initialization.
- `lib/_http_common.js`: `new HTTPParser(HTTPParser.REQUEST)` (reverse of fix hunk).
- `lib/_http_client.js`: removed `HTTPClientAsyncResource` and pass `req` directly to `initialize`
  (reverse of fix hunk).
The async_wrap.cc/h refactor (kInvalidAsyncId, EmitDestroy()) is left as is: the release already has it
and it is not itself the defect; the reusable AsyncWrap ctor remains unused-by-Parser.

## Failing tests (stable across 2 runs)
test-graph.http, test-httpparser.request, test-httpparser.response, test-http-parser,
test-http-parser-bad-ref, test-async-hooks-http-parser-destroy, test-async-wrap-getasyncid
(`new HTTPParser()` without type hits `CHECK(args[0]->IsInt32())` abort; graph/destroy tests see
wrong/missing init types and resources).
