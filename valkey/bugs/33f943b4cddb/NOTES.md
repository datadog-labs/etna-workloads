Reproducer: a client blocks with `BLPOP dst 2` on a non-existent key, then `RENAME src dst` creates the list.
Clean: the blocked client is woken and prints `dst` / `a`. Buggy: dbAdd no longer signals the key as ready for
lists created by RENAME (or SORT..STORE), so BLPOP just times out and returns nil (empty output).
