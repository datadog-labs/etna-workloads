# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 29921259e83b613a14d71d8b26fd5d0419944297 ("Teach psql to skip in-line COPY ... FROM STDIN data after a failure."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/common.c, src/bin/psql/common.h, src/bin/psql/copy.c, src/bin/psql/mainloop.c, src/bin/psql/psqlscanslash.l, src/bin/psql/startup.c, src/fe_utils/psqlscan.l, src/include/fe_utils/psqlscan.h, src/include/fe_utils/psqlscan_int.h

Failing oracle cases:
- `src/test/regress||alter_table`
- `src/test/regress||copy`
- `src/test/regress||copy2`
- `src/test/regress||copyselect`
- `src/test/regress||generated_stored`
- `src/test/regress||generated_virtual`
- `src/test/regress||privileges`
- `src/test/regress||psql`
- `src/test/regress||rowsecurity`
