Reproducer (`repro.sql`): builds an FTS3 table with 4 rows, shrinks the node size
with the undocumented `nodesize=24` command, runs an incremental merge
(`merge=10,2`), then `PRAGMA integrity_check`.

Clean shell prints `ok` twice. Buggy shell prints `ok`, then
"malformed inverted index for FTS3 table main.x1" after the merge, because
fts3IncrmergeAppend writes past the estimated leaf range.
