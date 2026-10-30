Reproducer: on one connection (via redis-cli stdin), issues CLIENT TRACKING ON BCAST with overlapping prefixes (FOOBAR/FOO, then FO and BARB against existing FOO/BAR).
Clean build replies with "ERR Prefix ... overlaps ..." errors; the buggy build skips the collision check and replies OK to all.
