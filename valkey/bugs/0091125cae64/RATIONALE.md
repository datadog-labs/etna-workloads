# LPOS crash on non-existing key

Fix hunk (src/t_list.c, lposCommand): replaced `lookupKeyWriteOrReply(c,c->argv[1],NULL)` with `lookupKeyRead(c->db,c->argv[1])`.

Reversed in 9.0.7 at `lposCommand` in src/t_list.c: the key lookup is again
`lookupKeyWriteOrReply(c, c->argv[1], NULL)`. When the key is missing, the helper calls
`addReplyOrErrorObject(c, NULL)`, which asserts/dereferences NULL and crashes the server.
This is the same defect (a NULL reply passed to the OrReply helper, plus a write lookup in a read-only command).
The code is equivalent to the pre-fix line; only the 9.0.7 helper's internals differ.

Oracle: "LPOS non existing key" sends LPOS on a missing key, and the server crashes
(assertion). The rest of the list.tcl run is incomplete, so 240 of 261 oracle cases are reported failing.
