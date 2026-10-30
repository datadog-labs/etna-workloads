# Rationale

Bug: RDB/RESTORE loading of a set ignored duplicate members (fix hunk in `rdbLoadObject`, `RDB_TYPE_SET`: `dictAdd(...)` became `if (dictAdd(...) != DICT_OK) { rdbExitReportCorruptRDB("Duplicate set members detected"); decrRefCount(o); sdsfree(sdsele); return NULL; }`). The corrupt payload was accepted and the duplicate element leaked.

Changes in `tree/src/rdb.c` (`rdbLoadObject`, set branch):
1. Hashtable-encoded set: `hashtableAdd()` result ignored again (reverses the `dictAdd` hunk; `hashtableAdd` is today's `dictAdd`). A duplicate is silently dropped and `sdsele` leaks.
2. Listpack-encoded set: removed the `lpFind` duplicate check. The fix's hunk has no listpack counterpart; this is a later path covering the same defect (duplicate set members accepted). Without it the payload in the oracle (which goes intset -> listpack) is still rejected, so reverting only (1) does not bring the bug back.

(The intset path's duplicate check is left as is.)

Oracle failure: `corrupt payload: fuzzer findings - leak in rdbloading due to dup entry in set` (corrupt-dump.tcl) — RESTORE returns OK instead of "Bad data format". The psync2 failures are flaky and unrelated.
