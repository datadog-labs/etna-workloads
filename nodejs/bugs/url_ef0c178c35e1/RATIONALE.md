# Re-introduced bug: pathToFileURL drops LF, CR and TAB (upstream ef0c178c35e1)

**Bug.** `url.pathToFileURL()` did not percent-encode `\n`, `\r` and `\t` in file paths. The WHATWG URL parser strips these characters, so `/foo\tbar` became `file:///foobar` instead of `file:///foo%09bar`. The same happened for `\n` (`%0A`) and `\r` (`%0D`).

**Change (src/node_url.cc, one hunk).** In the release, `pathToFileURL` no longer does the encoding in JS (`lib/internal/url.js`, where the fix added `newlineRegEx`, `carriageReturnRegEx` and `tabRegEx`). It builds the URL in C++, in `EncodePathChars`, using a `lookup_table`. I removed the three `ENCODE_CHAR` entries for `'\t'`, `'\n'` and `'\r'` from that table. This corresponds to the fix's three `resolved.replace(...)` hunks for `\n`, `\r` and `\t`. Those characters are now passed through unencoded and the URL parser strips them, which is the pre-fix behaviour.

**Failing test.** `parallel/test-url-pathtofileurl` reports `not ok`. The assertion message is:
`Expected values to be strictly equal: + actual 'file:///C:/foobar' - expected 'file:///C:/foo%09bar'`
It failed on both runs I did after the build.
