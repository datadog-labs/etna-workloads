# gh-102956 reintroduced in Lib/zipfile/__init__.py (ZipExtFile.seek)

Hunk 1 (reverses the fix's reordering): in v3.15.2 the "new position is inside
`_readbuffer`" branch already came first. I moved it back after the
"fast seek uncompressed unencrypted file" branch, so a ZIP_STORED, undecrypted
file takes the fast path even when the target is inside the read buffer.

Hunk 2 (same defect, second path): v3.15.2's fast-seek branch also does
`self._compress_left -= read_offset` and `self._eof = self._left <= 0`.
These were added after the original fix and made the fast path correct on its
own, so reordering alone does not bring the bug back. I removed those two
lines, which restores the pre-fix fast path. After a seek that discards the
read buffer, `_compress_left` stays 0 and `_eof` stays True, so `_read2()`
returns b'' and `read()` returns empty bytes. That is the symptom in the issue.

Failing oracle cases:
- OtherTests.test_read_after_seek: `read(-1)` after `seek(..., SEEK_CUR)` returns b'' instead of b'men!'.
- StoredZipExtFileRandomReadTest.test_stored_seek_and_read.
