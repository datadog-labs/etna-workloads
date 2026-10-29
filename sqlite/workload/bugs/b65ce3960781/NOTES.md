Builds a corrupt FTS3 segdir row (via `.dbconfig defensive off`) and runs
`matchinfo(t0,'sx')` with query `1* OR 1`. (The test's parentheses mode is a
TCL-only global, so the query was simplified to one that still hits the path.)
Clean shell: exits normally. Buggy shell: aborts with
`sqlite3Fts3DoclistNext: Assertion 'p || *piDocid==0' failed`
(fix turned that assert into assert_fts3_nc, which tolerates corruption).
