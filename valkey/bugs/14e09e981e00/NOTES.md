Starts a master with two replicas, SIGSTOPs one, then in a single connection runs `SET foo bar`, waits 3s (so the live replica acks), and runs `EVAL "return server.call('wait','2','0')" 0`.
Clean: WAIT in script returns 1 (uses the caller's woff). Buggy: returns 2, because the script's fake client has woff 0 so every replica counts.
