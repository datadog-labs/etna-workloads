# Rationale

All changes are in `src/backend/utils/adt/tsquery.c`. They restore the pre-fix behaviour: text in double quotes is parsed with an `in_quotes` state flag, not as a single token.

- `struct TSQueryParserStateData`: re-added the `in_quotes` field. Traces to the fix hunk that removes it.
- `parse_or_operator()`: returns false while `in_quotes` is set. Traces to the fix hunk that removes this check.
- `gettoken_query_websearch()`, `WAITOPERAND` case, `-` branch: while in quotes, a `-` is skipped and no NOT is emitted.
- `gettoken_query_websearch()`, `WAITOPERAND` case, `"` branch: replaced the single-token scan with the old logic. An opening quote returns `PT_OPEN` and sets `in_quotes`. A closing quote returns `PT_CLOSE` after `pushStop`.
- `gettoken_query_websearch()`, `WAITOPERATOR` case, `"` branch: re-added. Outside quotes it inserts an implicit AND. Inside quotes it closes the quotes with `PT_CLOSE`. The current code had no `"` branch here.
- `gettoken_query_websearch()`, `WAITOPERATOR` case, implicit-operator branch: inside quotes it emits `<->` (`OP_PHRASE`) instead of AND.
- `parse_tsquery()`: re-added `state.in_quotes = false;`.

These all trace to the corresponding hunks of `fix_impl.patch`, reversed. With them in place, a quoted string is split into several tokens joined by `<->` and is no longer one token. That changes the results of the `websearch_to_tsquery` cases.

## Failing oracle cases
- `src/test/regress||tsearch` fails with the change. It passed on the unmodified source.
