# Rationale

**Bug:** legacy `url.parse()` runs the hostname through IDNA `toASCII`, which can introduce characters
such as `/`, `:`, `@`, `?` or `#` (e.g. `℀` -> `a/c`), or empty the hostname (U+00AD). Without a check after
conversion, `url.parse('http://bad.c℀.good.com/')` yields a spoofed host/path split.

**Change (lib/url.js, one hunk plus cleanup):**
- In `Url.prototype.parse`, removed the post-`toASCII` check
  `if (this.hostname === '' || forbiddenHostChars.test(this.hostname)) throw new ERR_INVALID_URL(url)`.
  This corresponds to the fix's hunk adding that check (and its comment). In today's code the
  `hostname !== ''` guard and the `toASCII` call already differ in form (the guard is an outer `if`,
  and the IPv6 branch is separate), so only the added check was reverted.
- Removed the `forbiddenHostChars` regex definition (fix hunk adding the constant), since it's unused otherwise.
  `ERR_INVALID_URL` is still used elsewhere in the file.

**Failing test:** `parallel/test-url-parse-invalid-input` -> `not ok`,
`AssertionError [ERR_ASSERTION]: Missing expected exception: parsing http://fail⁇fail.com/`.
Failure was stable across two runs.
