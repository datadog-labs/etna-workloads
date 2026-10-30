Reproducer: over a raw RESP3 connection, enable client tracking, GET a key, then MSET that key
from the same connection. The invalidation push for the client's own write must arrive
after the MSET reply.

Clean: `+OK` (MSET reply) then the `>2 invalidate` push. Buggy: the push is sent before the `+OK`,
interleaved ahead of the command response.
