repro.sql mirrors fts5misc-14.0 to 14.4: in exclusive locking mode, a transaction
creates an fts5 table while two memdb databases (same store) are attached, so
ANALYZE and COMMIT fail with "database is locked". The second COMMIT re-syncs the
fts5 table in state 2.

Clean shell: the same error messages, and exit status 1.
Buggy shell: the second COMMIT hits the assertion
`p->ts.eState==1` in fts5CheckTransactionState and aborts (exit -6).
