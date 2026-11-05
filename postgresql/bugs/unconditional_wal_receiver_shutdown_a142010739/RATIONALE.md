# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a14201073965ba8c4d6e553b044e30efbf214c20 ("Fix unconditional WAL receiver shutdown during stream-archive transition"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlog.c, src/backend/access/transam/xlogrecovery.c, src/include/access/xlog.h

Failing oracle cases:
- `src/test/recovery|t/004_timeline_switch.pl|WAL receiver should not be stopped across timeline jumps`
