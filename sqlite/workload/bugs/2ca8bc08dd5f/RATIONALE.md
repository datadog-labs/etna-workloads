# Rationale

Fix hunk (src/vdbe.c, OP_Column): added `(zIdx==zEndHdr && offset!=payloadSize)` to the
corruption check, so a record whose header is fully consumed but whose field sizes don't
add up to the payload size is flagged SQLITE_CORRUPT.

In 3.54.1 the same check lives in OP_Column's header parsing (`src/vdbe.c`, ~line 3214):
`(zHdr>=zEndHdr && (zHdr>zEndHdr || offset64!=pC->payloadSize)) || offset64>pC->payloadSize`.
I reduced it to `zHdr>zEndHdr || offset64>pC->payloadSize`, the pre-fix condition, by dropping
the `offset64!=pC->payloadSize` clause (and its comment item (2)).

## Oracle failures
corrupt6-1.8.2 and corrupt6-1.9.2: a text serial type length decreased by 2 leaves the
header fully used but the data short of the payload end. It now returns
`0 {varint32 varint32}` instead of "database disk image is malformed".
