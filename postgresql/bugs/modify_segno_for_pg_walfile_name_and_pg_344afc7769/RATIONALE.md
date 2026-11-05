# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 344afc77690b4cef2605420d67c1d1ceb28760cc ("modify segno. for pg_walfile_name() and pg_walfile_name_offset()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlogfuncs.c

Failing oracle cases:
- `src/test/regress||misc_functions`
