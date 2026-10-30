Starts two cluster-enabled nodes, gives node 1 all slots, sets FOO with PX 10 (active expire off),
marks FOO's slot MIGRATING to node 2 and lets the key expire. `GET FOO` returns `ASK` in both builds.

Difference: in the clean build the redirect check does not delete the expired key (LOOKUP_NOEXPIRE),
so `expired_keys:0` and `dbsize` is 1. In the buggy build getNodeByQuery lazily deletes it outside
call(), so `expired_keys:1` and `dbsize` is 0 (the upstream failure was an assertion on the unflushed
propagation queue; here the stray deletion is visible via stats).
