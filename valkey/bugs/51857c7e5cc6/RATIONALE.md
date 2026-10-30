# Rationale

Fix hunk (src/rdb.h): `rdbIsObjectType` was not updated when a new hash RDB type
(ziplist hash, 13) was added, so `rdbLoadObjectType()` (used by RESTORE/MIGRATE
via cluster.c) rejected it.

In 9.0.7 the macro is `... || (t >= 9 && t < RDB_TYPE_LAST)`, so the range covers
every type. I re-created the omission for the current default small-hash
encoding: the macro now excludes `RDB_TYPE_HASH_LISTPACK` (16). Same defect: a
hash type that is missing from the object-type test. Only src/rdb.h line 130 changed.

Oracle: "MIGRATE can correctly transfer hashes" fails (a small hash is dumped as
listpack; RESTORE on the target rejects the payload as bad). Other DUMP/RESTORE
cases that use small hashes may fail too.
