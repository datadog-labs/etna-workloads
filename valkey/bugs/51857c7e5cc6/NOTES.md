Starts two servers, creates a small (listpack-encoded) hash and MIGRATEs it to the second server, then reads it back.
Clean: MIGRATE returns OK and HGETALL on the target shows the hash.
Buggy: rdbIsObjectType rejects RDB_TYPE_HASH_LISTPACK, so the target replies "ERR Bad data format" and the key is not transferred.
