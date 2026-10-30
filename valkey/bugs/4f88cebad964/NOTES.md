Starts a primary and a replica, sets a field with a long TTL (HSETEX), then runs HINCRBYFLOAT on it.
Clean build: the command is replicated as HSETEX ... PXAT, so the replica keeps the TTL.
Buggy build: it is replicated as a plain HSET, which drops the TTL on the replica, so the replica prints `ttl-set=no`.
