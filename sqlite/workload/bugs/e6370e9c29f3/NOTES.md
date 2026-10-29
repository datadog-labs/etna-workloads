Reproducer (`repro.sh`): creates a small 1024-byte-page database, then overwrites the
"database size in pages" header field (offset 28) with 0xd0000000, which is negative
when read as a signed int. The change counter still matches version-valid-for, so the
field is trusted.

Clean shell: the open fails with "Parse error ... database disk image is malformed (11)", exit 1.
Buggy shell: `nPage` is a signed int in lockBtree(), so the check is bypassed; the query succeeds
and prints `1|2`.

Not covered: the REINDEX-on-virtual-table part of the fix (rtree17.x). I couldn't make it
differ from a plain shell session, and none of the listed failing tests needs it.
