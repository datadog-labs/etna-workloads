# Rationale

File: src/backend/commands/sequence.c, function pg_sequence_last_value().
Traces to the fix.patch hunk that added the guard `(RelationIsPermanent(seqrel) || !RecoveryInProgress())` so that unlogged sequences on a standby return NULL instead of reading the (nonexistent) tuple.
The current code has the guard merged with the ACL check; I removed only the standby condition. On a standby, pg_sequences / pg_sequence_last_value() on an unlogged sequence now calls read_seq_tuple() and errors out ("cannot access temporary or unlogged relations during recovery"), the original bug.

Failing oracle cases: 59 of 63 in src/test/recovery t/001_stream_rep.pl (the script's standby queries fail, so nearly every case after setup is missing). Full list is in logs/oracle.log.
