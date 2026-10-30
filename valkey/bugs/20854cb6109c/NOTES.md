Reproducer: creates a listpack-encoded SET (7 members) and a 2-member ZSET, then runs ZINTER / ZINTERCARD.
The set is the larger input, so zuiFind() is called on it.
Clean: replies `1 2` / `2`, server stays up. Buggy: zuiFind has no listpack branch and hits
serverPanic("Unknown set encoding"), so the server aborts and the connection drops (script prints PANIC).
