# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8da86d62a11269e926765c0d6ef6f532b2b8b749 ("Fix minmax-multi on infinite date/timestamp values"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/brin/brin_minmax_multi.c

Failing oracle cases:
- `src/test/regress||brin_multi`
