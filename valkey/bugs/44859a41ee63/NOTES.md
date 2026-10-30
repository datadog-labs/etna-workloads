repro.sh opens a raw RESP3 connection, enables CLIENT TRACKING with NOLOOP, does SET/GET key1, then runs EVAL that calls SET on key1 and a PING.
Clean: no invalidate push is sent to the client (it is the one modifying the key). Buggy: the script's inner client is compared instead of the current client, so an `invalidate` push arrives before PONG.
