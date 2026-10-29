repro.sql replays fts5aa test 24 (default detail=full): in one transaction, DELETE a row, query the
term (reads the in-memory hash mid-transaction), then re-insert the same row.
Clean: integrity-check passes and the final SELECT returns `aaaa`, exit 0.
Buggy: the query finalizes the hash entry's poslist size in place, so later writes corrupt it;
integrity-check and the final SELECT fail with "fts5: corruption found reading blob ...", exit 1.
