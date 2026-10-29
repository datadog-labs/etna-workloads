`repro.sql` is btree01-2.1 translated to SQL. It builds a WITHOUT ROWID table with one large (1000-byte) overflow row, then runs a LEFT JOIN that does repeated index lookups. That exercises the stay-on-last-page path in `sqlite3BtreeIndexMoveto()`.

Clean shell: prints `198|99`, `187|`, `100|50`, exit 0.
Buggy shell: aborts with `Assertion '(pCur->curFlags & BTCF_ValidOvfl)==0' failed` in `sqlite3BtreeIndexMoveto`. The injection stops that path from clearing `BTCF_ValidOvfl`.
