# Rationale

Bug: `pathToFileURL` did not percent-encode several RFC1738 "unsafe" characters (`[`, `]`, `^`, `|`, `~`), so e.g. `/foo[bar` yielded `file:///foo[bar` instead of `file:///foo%5Bbar`.

In this release the fix's JS `encodePathChars` logic moved into the C++ lookup table in `src/node_url.cc` (used by `pathToFileURL`). Change (single hunk): removed the `ENCODE_CHAR` entries for `[`, `]`, `^`, `|`, `~` from `lookup_table`. This corresponds to the fix's hunk adding `openSquareBracketRegEx`, `closeSquareBracketRegEx`, `caretRegEx`, `verticalBarRegEx`, `tildeRegEx` replacements in `encodePathChars`; removing them restores the pre-fix behaviour of leaving these characters unencoded. (The `execution.js` hunk has no analogue needing change.)

Failing test: `parallel/test-url-pathtofileurl` — AssertionError: actual `'file:///C:/foo[bar'`, expected `'file:///C:/foo%5Bbar'`.
