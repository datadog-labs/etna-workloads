repro.sql: copies a row with rowid 888 into an empty AUTOINCREMENT table via
`INSERT ... SELECT` (xfer optimization), then reads sqlite_sequence.
Clean shell: `t10a|888` and `t10b|888`. Buggy shell: no t10b row, because
sqlite3AutoincrementEnd is skipped on the xfer path.
