Reproducer: master + AOF-enabled replica (appendfsync always). The replica is SIGSTOPped, two clients each
do `incr foo` then `waitaof 0 1 0` on the same connection (both block), then the replica is resumed so both unblock together.

Clean: both clients get the WAITAOF reply `[1, 1]`; the script prints total reply lines = 6.
Buggy: WAIT and WAITAOF share the "reuse last result" cache, so one client gets a bare integer
reply instead of the two-element array; the script prints 5.
Which client gets the bare integer varies, so the script prints only the total line count.
