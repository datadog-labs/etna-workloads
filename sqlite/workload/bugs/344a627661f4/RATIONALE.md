# Rationale

Fix hunk (src/prepare.c): after parsing, `if( sqlite3MallocFailed() ) sParse.rc = SQLITE_NOMEM;`
so that an OOM during prepare is reported rather than returning SQLITE_OK.

In 3.54.1 this logic exists in two places (same defect, fixed twice):
1. `src/prepare.c` sqlite3Prepare(): removed `if( db->mallocFailed ){ sParse.rc = SQLITE_NOMEM_BKPT; sParse.checkSchema = 0; }`
   (direct equivalent of the fix hunk).
2. `src/tokenize.c` sqlite3RunParser(): removed `if( db->mallocFailed ){ pParse->rc = SQLITE_NOMEM_BKPT; }`
   which independently covers the same case; reverting only (1) left the bug masked (oracle all passing).

Effect: a malloc failure during prepare no longer sets rc=NOMEM, so a statement is returned/leaked
(or errors misreported) after OOM.

Oracle: with both changes, test/malloc.test crashes/asserts under OOM injection
(~18319 of 18659 cases fail/incomplete, incl. malloc-1.X etc.).
