# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 33101632235ad064b2bd7bc04a5066048dc48023 ("Fix cascading standby reconnect failure after archive fallback"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/libpqwalreceiver/libpqwalreceiver.c, src/backend/replication/walreceiver.c, src/include/replication/walreceiver.h

Failing oracle cases:
- `src/test/recovery|t/055_cascade_reconnect.pl|cascade streaming resumes normally after upstream catches up`
- `src/test/recovery|t/055_cascade_reconnect.pl|no errors in stubble log`
