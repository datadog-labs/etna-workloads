# Rationale

Fix: MSETNX with the same key twice asserted, because the fix reverted #11594 (passing a "key doesn't exist" flag to setKey for every key in MSETNX).

In 9.0.7 `msetGenericCommand` (src/t_string.c) passes `SETKEY_DOESNT_EXIST` when `nx`, but then switches to `SETKEY_ADD_OR_UPDATE` after the first key. That reset is the equivalent of the fix's removal of `setkey_flags |= SETKEY_DOESNT_EXIST` and its per-key flag handling. I removed the reset, so every key in MSETNX is set with `SETKEY_DOESNT_EXIST`. When the same key appears twice, the second setKey assumes the key is absent and calls dbAdd on an existing key, which trips an assertion.

Failing oracle cases: "MSETNX with not existing keys - same key twice" (server crashes on the assertion), and the cases after it in the file.
