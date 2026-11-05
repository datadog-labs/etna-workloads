# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 321ec54625fdb79accba41c8094da382a4f89aa2 ("Fix bug where we truncated CLOG that was still needed by LISTEN/NOTIFY"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/async.c, src/backend/commands/vacuum.c, src/include/commands/async.h

Failing oracle cases:
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#10`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#11`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#12`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#3`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#4`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#5`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#6`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#7`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#8`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|#9`
- `src/test/modules/xid_wraparound|t/004_notify_freeze.pl|received all committed notifications`
