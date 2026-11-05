# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit becfbdd6c1c94fe03391368080029a6dd8523658 ("Fix edge-case for xl_tot_len broken by bae868ca."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlogreader.c

Failing oracle cases:
- `src/test/recovery|t/039_end_of_wal.pl|xl_tot_len short at end-of-page`
