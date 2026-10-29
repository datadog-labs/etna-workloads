repro.sql uses `.connection` to open two shared-cache connections to one in-memory
database (auto_vacuum=2, ~128 rows of 1KB). Connection 0 runs BEGIN; DELETE;
PRAGMA incremental_vacuum (sets bDoTruncate), then connection 1 reads
sqlite_master, which begins a read transaction on the shared BtShared.
Clean shell: completes normally. Buggy shell: aborts with
`btreeBeginTrans: Assertion IfNotOmitAV(pBt->bDoTruncate)==0 failed`.
