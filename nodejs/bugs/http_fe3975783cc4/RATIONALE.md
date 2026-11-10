# Re-introduced bug: trailing OWS not stripped from HTTP header values

**Bug:** The HTTP parser handed header values to JS with trailing OWS (SP/HTAB) intact, so e.g. `host: foo.com\t` produced `req.headers.host === 'foo.com\t'`, causing spurious inequality (HackerOne 730779).

**Change (src/node_http_parser.cc, one hunk):** In `Parser::CreateHeaders`, `values_[i].ToTrimmedString(env())` is changed back to `values_[i].ToString(env())`. This corresponds to the fix's hunk that switched `CreateHeaders` from `ToString` to `ToTrimmedString`. The other fix hunks (IsOWS, ToTrimmedString helper, ToString size check) are left in place, since the helper is now unused but harmless and the reverse patch no longer applies cleanly; leaving trimming out of the call site restores the old behaviour.

**Failing test:** `parallel/test-http-header-owstext` fails ("not ok") with an AssertionError: the server's `req.headers.host` still contains trailing whitespace, e.g. `'foo.com\t'` instead of `'foo.com'`.
