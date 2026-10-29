repro.sh mirrors wal-20: connection 1 (kept open through a fifo) creates a WAL table; a second
process then inserts ~16K 900-byte rows in one transaction, so the wal-index grows past 64KB;
connection 1 then checkpoints and counts rows.
Clean: writer exits 0, checkpoint reports 0|4110|4110, counts are 16384, integrity ok.
Buggy: the writer process aborts (assertion `0` in walHashGet, exit 134), the WAL is not
populated, and the counts are 1.
