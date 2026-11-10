# Rationale

Bug: `util.inspect` string escaping did not escape C1 control characters (U+007F–U+009F) and
used the `\u00XX` format for control characters instead of `\xXX`.

Hunks (all in lib/internal/util/inspect.js):
1. The four `strEscapeSequences*` regexes lose `\x7f-\x9f` (fix hunk 1 reversed), so strings with C1 chars skip the escape path.
2. The `meta` table is restored to the old `\u00xx` lowercase format and truncated at 0x5c (fix hunk 2 reversed).
3. `strEscape` condition drops `(point > 126 && point < 160)` (fix hunk 3 reversed).

Failing: parallel/test-util-inspect (e.g. `util.inspect('\n\x01')` gives `'\n\u0001'` instead of `'\n\x01'`).
parallel/test-fs-whatwg-url still passed in my run (its message is evidently not produced via this path in this release).
