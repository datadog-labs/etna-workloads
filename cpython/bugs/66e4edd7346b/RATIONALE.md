# Rationale

Hunk reversed: `Include/cpython/object.h`, `tp_watched` changed from `unsigned char` back to `char`
(the fix's only implementation hunk; the Doc hunks are documentation only).

With signed `char` (x86), setting bit 7 (watcher id 7) makes `tp_watched` negative. The
`bits = type->tp_watched` / `bits >>= 1` loops in `Objects/typeobject.c` (type_modified /
notify) then sign-extend and never reach 0, so they loop past the 8 watcher slots. The result is an
abort or segfault when all 8 slots are used.

Oracle: `TestTypeWatchers.test_all_watchers` fails. The run crashes, so the other
TestTypeWatchers cases are reported as failing too (incomplete run).
