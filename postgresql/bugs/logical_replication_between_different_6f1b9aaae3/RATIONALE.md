# Rationale

File: src/backend/replication/logical/proto.c, function logicalrep_write_tuple (text branch).

Traces to the fix.patch hunk replacing the manual `len = strlen+1; pq_sendint; pq_sendstring` with `pq_sendcountedtext`.
The change restores the old code: the length is computed from the server-encoding string (plus NUL) and then
`pq_sendstring` converts to the client encoding. After conversion the byte count can differ, so the length prefix
no longer matches the data when the publisher and subscriber encodings differ. This breaks replication between different encodings.

The read-side hunk (logicalrep_read_tuple) is not reverted. Today's code already NUL-terminates the buffer itself, so the old read code has no equivalent to restore.

Failing oracle case:
- src/test/subscription|t/005_encoding.pl|data replicated to subscriber
