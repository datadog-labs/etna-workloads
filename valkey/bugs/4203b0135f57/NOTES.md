Reproducer: starts a primary and a replica (hz 500), then 30 times changes the primary's replid
(`debug change-repl-id`), does `replicaof no one` + `replicaof` again (the replica caches then
discards its primary client), and writes a 1MB value. Finally it checks the replica's
`mem_clients_normal`.

Clean: stays ~1.6KB. Buggy: freeClient() skips the stat rollback for the cached primary
(conn is NULL), so it leaks ~1.6KB per cycle (~49KB after 30), and the script prints
"mem_clients_normal leaked" instead of "small".
