# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1d3743023ef8fa665902e791b0d52e9a1ab419cb ("Fix walsender error cleanup code"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/replication/walsender.c

Failing oracle cases:
- `src/test/recovery|t/006_logical_decoding.pl|Check that reset timestamp is later after resetting stats for slot 'test_slot' again.`
- `src/test/recovery|t/006_logical_decoding.pl|Check that reset timestamp is later after the second reset of stats for slot 'test_slot' and confirm total_bytes was set to 0.`
- `src/test/recovery|t/006_logical_decoding.pl|Decoding after fast restart repeats no rows`
- `src/test/recovery|t/006_logical_decoding.pl|Decoding produced 12 rows inc BEGIN/COMMIT`
- `src/test/recovery|t/006_logical_decoding.pl|Logical decoding fails on non-database connection`
- `src/test/recovery|t/006_logical_decoding.pl|READ_REPLICATION_SLOT not supported for logical slots`
- `src/test/recovery|t/006_logical_decoding.pl|Stats_reset is NULL for slot 'logical_slot' before reset.`
- `src/test/recovery|t/006_logical_decoding.pl|Stats_reset is not NULL for slot 'logical_slot' after reset all.`
- `src/test/recovery|t/006_logical_decoding.pl|Total bytes is > 0 and stats_reset is NULL for slot 'test_slot'.`
- `src/test/recovery|t/006_logical_decoding.pl|dropping a DB with active logical slots fails`
- `src/test/recovery|t/006_logical_decoding.pl|dropping a DB with inactive logical slots succeeds`
- `src/test/recovery|t/006_logical_decoding.pl|got expected output from SQL decoding session`
- `src/test/recovery|t/006_logical_decoding.pl|got same expected output from pg_recvlogical decoding session`
- `src/test/recovery|t/006_logical_decoding.pl|logical slot advance persists across restarts`
- `src/test/recovery|t/006_logical_decoding.pl|logical slot still exists`
- `src/test/recovery|t/006_logical_decoding.pl|logical slot was actually dropped with DB`
- `src/test/recovery|t/006_logical_decoding.pl|pg_recvlogical acknowledged changes`
- `src/test/recovery|t/006_logical_decoding.pl|replaying logical slot from another database fails`
- `src/test/recovery|t/006_logical_decoding.pl|slot advancing with logical slot`
