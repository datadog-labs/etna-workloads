# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b903d17927eecab8dd741eb71f04eee5a1182eff ("Avoid exposing WAL receiver raw conninfo during timeline jumps"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/replication/walreceiverfuncs.c

Failing oracle cases:
- `src/test/recovery|t/004_timeline_switch.pl|pg_stat_wal_receiver.conninfo not updated across timeline jumps`
