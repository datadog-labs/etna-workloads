repro.sh stores a hash and runs `redis.setresp(3); return redis.call('hgetall', ...)` from a RESP2 client and a RESP3 client (`-3`).
Clean build: the reply is field/value (RESP2) and `field value` (RESP3 map).
Buggy build: the Lua map reply is emitted value-first, so the RESP2 reply is `value, field` and the RESP3 map is `value => field`.
