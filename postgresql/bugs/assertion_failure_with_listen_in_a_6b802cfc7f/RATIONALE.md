# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6b802cfc7fab0f38001ae465ccd4f7f565b6169d ("Avoid assertion failure with LISTEN in a serializable transaction."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xact.c

Failing oracle cases:
- `src/test/isolation||async-notify`
