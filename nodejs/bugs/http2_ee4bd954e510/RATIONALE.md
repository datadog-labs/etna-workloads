# Re-introduced bug: http2 pseudo-header order

**Bug.** `mapToHeaders`/header building accumulated every header into one string, and each pseudo-header was *prepended* to it. Pseudo-headers therefore went out in reverse of the order given, and the order was not the one the user sent. The fix collects pseudo-headers and regular headers separately, appends each in sent order, and returns `pseudoHeaders + headers`.

**Change (lib/internal/http2/util.js, `buildNgHeaderString`)** — it matches all three hunks of the fix, adapted to today's code:
1. Removed the separate `pseudoHeaders` accumulator (fix hunk 1: `let ret` split into `headers`/`pseudoHeaders`).
2. For pseudo-headers, `headers = \`${key}\0${value}\0${flags}${headers}\`` prepends, as the old `ret = ...${ret}` did (fix hunk 2).
3. `return [headers, count]` replaces `[pseudoHeaders + headers, count]` (fix hunk 3).

**Failing tests** (all 3 oracle cases show "not ok", stable across 2 runs): test-http2-util-headers-list, test-http2-multiheaders-raw and test-http2-compat-serverrequest-headers. They fail on assertions where the pseudo-header order in the rawHeaders or the mapToHeaders output differs from the order sent.
