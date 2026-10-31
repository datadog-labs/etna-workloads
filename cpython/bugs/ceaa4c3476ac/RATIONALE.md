# Rationale (gh-103987, mmap use after close)

Changes in tree/Modules/mmapmodule.c remove the post-conversion validity
rechecks that the fix added (and v3.15.2 retained, with comments in two places):

- `mmap_gfind_lock_held`: removed `CHECK_VALID` before the find (fix hunk in mmap_gfind). `start`/`end` objects are converted by `__index__`, which can close the map.
- `mmap_subscript_lock_held`: removed `CHECK_VALID` after the index bounds check and the one after the slice unpack (the two mmap_subscript hunks).
- `mmap_ass_subscript_lock_held`: removed `CHECK_VALID` after the item/value conversions and `CHECK_VALID_OR_RELEASE` after `PyObject_GetBuffer` (the two mmap_ass_subscript hunks).

Not reverted: read/write/write_byte/move/madvise hunks. In v3.15.2 their arguments are converted by Argument Clinic before the impl runs, so the impl's leading `CHECK_VALID` already sits after conversion and is the same code as the fix's added check; reversing would not give the pre-fix behaviour.

Oracle: `test_mmap_closed_by_int_scenarios` fails; the run crashes (segfault/abort, "incomplete run"), so later cases in the file are also reported failing.
