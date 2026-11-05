# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b381d9637030c163c3b1f8a9d3de51dfc1b4ee58 ("Add timeline ID to file names generated with pg_waldump --save-fullpage"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_waldump/pg_waldump.c

Failing oracle cases:
- `src/bin/pg_waldump|t/002_save_fullpage.pl|LSN stored in the file <N>/017832F0 precedes the one stored in the block <N>/<N>`
- `src/bin/pg_waldump|t/002_save_fullpage.pl|verify filename format for file <N>-<N>-017832F0.1663.5.<N>.0_main`
- `src/bin/pg_waldump|t/002_save_fullpage.pl|verify that at least one block has been saved`
