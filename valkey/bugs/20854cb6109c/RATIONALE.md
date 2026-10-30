# Rationale

Changed only `zuiFind` in `src/t_zset.c`, reversing the fix's t_zset.c hunk.

The fix replaced the encoding-specific SET branch (intset / hashtable only,
`serverPanic("Unknown set encoding")` otherwise) with a call to
`setTypeIsMemberAux`, which handles the listpack encoding. In 9.0.7 the
code already called `setTypeIsMemberAux`; I restored the old branch, using
`string2ll`/`intsetFind` for intsets and `hashtableFind` for hashtables.
A listpack-encoded SET now reaches the panic, so ZINTER, ZINTERSTORE,
ZINTERCARD, ZDIFF and ZDIFFSTORE crash, as in the original bug.

The other fix hunks are not reverted. The `db.c` SCAN change and the
`module.c` RM_ScanKey change are already in 9.0.7 in their fixed form. The
`#include "intset.h"` changes are header hygiene only.

## Oracle failure
`tests/unit/type/zset.tcl`, "zunionInterDiffGenericCommand acts on SET and
ZSET", and the later tests in the file that run zset operations against
listpack sets. The server hits `serverPanic("Unknown set encoding")`, so
the test client sees a connection error.
