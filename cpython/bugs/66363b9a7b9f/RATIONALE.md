# Rationale

Fix hunk reversed: the `open()` check in `Lib/zipfile/__init__.py` that raises
`BadZipFile("Overlapped entries: ... (possible zip bomb)")` when
`zef_file.tell() + zinfo.compress_size > zinfo._end_offset`.

In v3.15.2 that check had been extended (full overlap, where
`_end_offset == header_offset`, only warns). I removed the whole block, which is
the pre-fix behaviour: the `_end_offset` bookkeeping stays, but nothing checks
it. The `_end_offset` slot and the `_RealGetContents` computation are
left alone; they are harmless without the check.

Oracle: `OtherTests.test_quoted_overlap` fails (`BadZipFile not raised` for
`zipf.read('a')`). Other tests also fail that exercise the overlap check
(for example the full-overlap/overlap-warning tests).
