# Re-introduced bug: ParseEncoding (nodejs/node#33957)

**Bug:** In the `'u'`/`'U'` case of `ParseEncoding` (src/api/encoding.cc), the `utf-`/`ucs-` prefix was skipped by advancing the `encoding` pointer itself. The later case-insensitive fallbacks (`StringEqualNoCase(encoding, "utf-16le")` and similar) then compared the shifted string. Two things went wrong. `utf-16LE` returned UNKNOWN, because the fallback saw `16LE`. `utf-buffer` returned BUFFER, because the fallback saw `buffer`. Also, `strncmp(encoding, "16le", 4)` accepted trailing garbage, so `utf-16leNOT` returned UCS2.

**Hunks** (both in src/api/encoding.cc, `case 'u'`):
1. The utf branch goes back to `encoding += ...` with `encoding[0]`/`encoding[1]` checks and `strncmp(encoding, "16le", 4)`. This matches the fix's first hunk, which replaced the pointer mutation with `skip` and changed the strncmp length from 4 to 5.
2. The ucs branch goes back to `encoding += ...` with `encoding[0]`/`encoding[1]` checks. This matches the same fix hunk for the ucs2 branch.

I did not revert the `StringEqualNoCase` rewrite in util-inl.h or the strncmp lengths in the other cases. The reintroduced defects only need the `'u'` case.

**Result:** The build succeeded. `addons/parse-encoding/test` gives `not ok 1` on two consecutive runs. The new assertions fail, for example `utf-16LE` returns UNKNOWN instead of UCS2.
