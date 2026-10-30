# Rationale

Fix hunk reversed: `hexpireGenericCommand` skipped the delete path when `set_expired && !(flag & EXPIRE_GT)`.
In 9.0.7 the deletion decision moved into `hashTypeSetExpire` (src/t_hash.c), which runs the NX/XX/GT/LT
checks first and only then deletes when the time is in the past. Reversing the old hunk is therefore not possible.

Change: in the hashtable branch of `hashTypeSetExpire`, an already-expired time now deletes the field
immediately, before the flag conditions are evaluated. This restores the pre-fix behaviour where a past time
ignored the GT condition (and the other conditions) and acted like HDEL. The listpack branch is left alone
because it already failed GT/XX first.

Oracle failure: `HEXPIRE GT - Do not expire items when expiration in the past` expects `0 -2` but gets `2 -2`,
and the field is deleted. It is the only failing case (1 of 408).
