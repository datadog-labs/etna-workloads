Reproducer for the near-2^63 HPEXPIREAT bug (vset get_bucket_ts overflow).
repro.sh sets 128 hash fields, gives 126 of them an expiry of 2^63-8192 ms,
then adds f127 at 2^63-8192+8000 and f128 at 2^63-8192. That splits a full
vector bucket into the rax encoding.

Clean: all replies are normal and the server answers PONG with HLEN 128.
Buggy: the bucket timestamp overflows to a negative value and the server hits an
assertion on the last HPEXPIREAT. The connection closes, the server aborts,
and the script prints ASSERTION.

The LLONG_MAX case from the other new test did not show a difference in
my run, so I did not use it.
