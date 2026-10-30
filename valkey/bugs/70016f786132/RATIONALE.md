# Rationale

Fix (antirez merge of #6574, "XADD with ID 0-0 stores an empty key") made XADD
return early on ID 0-0, before the stream key is created, so that
streamAppendItem failing doesn't leave an empty key in the keyspace.

Changed: `src/t_stream.c`, `xaddCommand`: removed the early-return block
(`id_given && seq_given && id == 0-0` -> "The ID specified in XADD must be
greater than 0-0"). Now the stream is created by `streamTypeLookupWriteOrCreate`
first, then `streamAppendItem` fails with EDOM, so an empty stream key is
left behind (and the error text differs) — the pre-fix behaviour.

Failing oracle case: `XADD with ID 0-0` (`r EXISTS otherstream` == 0 assertion
fails because the empty key exists).
