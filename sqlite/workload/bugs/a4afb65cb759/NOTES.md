repro.sh holds an exclusive lock from one shell and runs `BEGIN IMMEDIATE` with `.timeout 500` from another.
Clean: the shared busy counter (nBusy) is used by both btree and pager, so the wait is ~0.5s.
Buggy: the btree layer uses its own local counter starting at 0 (separate from the pager's), so the
handler's budget is restarted and the wait is ~1s. The script prints "short" vs "long" based on elapsed time
(clean: short, buggy: long). This corresponds to busy-1.4 / busy-1.3 (busy handler arg sequence).
