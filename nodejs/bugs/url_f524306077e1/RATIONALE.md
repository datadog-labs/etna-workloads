# Re-introduced bug: NULL in IPv6 hostname accepted by url.parse (fix f524306077e1)

**Bug.** `url.parse()` did not validate IPv6 hostnames at all, and the forbidden-host-char regex lacked `\0`. A URL like `http://[127.0.0.1\x00c8763]:8000/` was parsed without throwing `ERR_INVALID_URL`.

**Changes (lib/url.js only).**
1. Hunk 1 of the fix (regex): `forbiddenHostChars` no longer contains `\0`, and the `forbiddenHostCharsIpv6` regex is removed. This restores the original definition.
2. Hunk 2 of the fix (validation block): restored the old `if (!ipv6Hostname && this.hostname !== '') { toASCII; check forbiddenHostChars }` structure, so IPv6 hostnames skip all validation. The release's `toASCII(this.hostname)` call (no lenient flag) was left unchanged, since the code has moved on.

**Failing test.** `parallel/test-url-parse-invalid-input` fails with "not ok" in two consecutive runs. The assertion on `url.parse('http://[127.0.0.1\x00c8763]:8000/')` fails with ERR_ASSERTION because no ERR_INVALID_URL is thrown.
