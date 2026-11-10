# Re-introduced bug: http parser `finish()` swallows errors

**Bug:** After the llhttp refactor, `Parser::Finish()` stopped returning the parse error (e.g. HPE_INVALID_EOF_STATE) to JS, so a request truncated mid-header at EOF is not reported as a `clientError`.

**Change (src/node_http_parser.cc, `Parser::Finish`):** the fix's first hunk set the return value from `Execute(nullptr, 0)` when non-empty. Today's `Execute` already builds the error object (the fix's other hunks were re-expressed upstream), so I re-created the old defect by discarding the result of `parser->Execute(nullptr, 0)` in `Finish` — the error is never handed back to the user.

**Failing test:** `parallel/test-http-parser-finish-error` fails (`not ok`, exitcode 1) because the `clientError` handler is never called. Stable across two runs.
