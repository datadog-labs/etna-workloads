# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9ba7bcc894f1cafb0793a3a62658bd91db1dbecf ("Correct relation size estimate with low fillfactor"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/table/tableam.c

Failing oracle cases:
- `src/test/regress||stats`
