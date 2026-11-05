# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 68a2a437f46716efd54d177edf9dbcc9916c903b ("Improve ereports for VACUUM's BUFFER_USAGE_LIMIT option"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/vacuum.c

Failing oracle cases:
- `src/test/regress||vacuum`
