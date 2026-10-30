Reproducer: master + replica, `SET foo bar` then `DELIFEQ foo bar` on master, wait for replication, then EXISTS foo on both.
Clean: DELIFEQ is propagated as DEL, so both report 0. Buggy: DELIFEQ isn't propagated (and no dirty/keyspace event), so the replica still has foo (replica exists: 1).
