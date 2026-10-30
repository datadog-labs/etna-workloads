repro.sh creates a hash with a volatile field (HSETEX EX 100), then overwrites the key with SET (string).
INFO keyspace then shows keys_with_volatile_items=0 on clean, but stays at 1 on buggy
(the old hash is no longer untracked in setKey/dbSetValue).
