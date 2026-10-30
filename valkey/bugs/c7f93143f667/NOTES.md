Blocks a client on `BLPOP k 2`, then `RENAME tmp k` moves a list into place.
Clean: the blocked client is woken and prints `k` / `a`. Buggy: dbAdd no longer signals
list keys as ready (and RENAME path doesn't), so BLPOP times out and prints nothing.
