# Rationale

Hunk changed: `Lib/pdb.py`, `_PdbClient._readline`.

Reverses the part of fix hunk `_PdbClient._readline` (added by gh-132975) that,
when the signal wakeup socket becomes readable, only raises `KeyboardInterrupt`
if `self.sigint_received` is set; otherwise the wakeup byte belongs to a SIGINT
that was already handled (e.g. raised inside `input()`) and must be ignored.
The bug version raises `KeyboardInterrupt` unconditionally on any wakeup byte,
so stale wakeup events cause a spurious extra interrupt (a second SIGINT sent
to the remote) -- the "interrupt handling" defect the fix addressed.

Oracle failures (4 in test_remote_pdb, PdbClientTestCase interrupt tests):
e.g. the outgoing signals are `[SIGINT, SIGINT]` instead of `[SIGINT]`.
