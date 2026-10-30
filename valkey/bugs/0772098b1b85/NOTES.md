Starts one server and issues EXPIRE/SET EX/PEXPIRE with huge values that overflow when converted to ms or when the base time is added.
Clean: each returns "invalid expire time" errors. Buggy: the overflow wraps, so EXPIRE returns 1 and deletes the key (TTL -2), SET EX succeeds but the key is already gone, and PEXPIRE/EXPIRE silently delete keys.
