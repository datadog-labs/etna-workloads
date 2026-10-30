repro.sh enables import-mode, sets a key, runs `EXPIREAT foo -1`, then disables import-mode and waits for active expiration.
Clean: the negative expire time is clamped to 0, the key is expired and dbsize becomes 0, and the server stays up.
Buggy: the negative time is stored as-is. Active expiration asserts and the server aborts, so later CLI calls fail to connect and the log contains "ASSERTION FAILED".
