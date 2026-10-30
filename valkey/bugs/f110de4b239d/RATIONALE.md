# Rationale

Fix hunk: `hashTypeSet` in src/t_hash.c gained a pre-insert check that converts a listpack hash to
hashtable when the field or value exceeds `hash-max-listpack-value` (needed for HINCRBY/HINCRBYFLOAT,
which skip `hashTypeTryConversion`).

In 9.0.7 the same check lives at the top of `hashTypeSet` (now combined with `expiry != EXPIRY_NONE`).
I removed the `sdslen(field) > hash_max_listpack_value || sdslen(value) > hash_max_listpack_value`
conditions, leaving only the unrelated expiry conversion. This is the pre-fix state: HINCRBY*
no longer converts the encoding when the result/field is too long.

Oracle failure: `HINCRBYFLOAT over hash-max-listpack-value encoded with a listpack`
(`Expected 'listpack' to match 'hashtable'`). The other 74 cases pass.
