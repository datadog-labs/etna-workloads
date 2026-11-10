# Re-introduced bug: utf16le write clobbers byte after target

**Bug.** `StringBytes::WriteUCS2` for an unaligned destination wrote the string into an aligned scratch position (dst rounded up by 1 byte) and then shifted left. Writing the full character count there put the last char's second byte one byte past the end of the target region (dst + nchars*2), corrupting adjacent memory (issue #26422).

**Hunk (src/string_bytes.cc, unaligned branch).** The fix writes only `nchars - 1` chars to `aligned_dst`, memmoves them, and writes the last char separately with memcpy. The current code (using `WriteV2`) already had this shape, so the reversal is re-expressed: I replaced the three steps with `WriteV2(isolate, 0, nchars, aligned_dst)` followed by `memmove(dst, aligned_dst, nchars * sizeof(*dst))`. This is the pre-fix behaviour, where the full write overruns by one byte.

**Failing test.** `parallel/test-buffer-write` fails (stable over 2+ runs): `buf.write('ыы', 1, 'utf16le')` leaves byte 5 as 4 instead of 0 (deepStrictEqual diff `+ 4, - 0`).
