Single-node cluster with AOF: SET k0, BGREWRITEAOF, SET k1, then MULTI/SET k0/APPEND k0/EXEC, then DEBUG LOADAOF.
Clean: dbsize 2, k0="cd". Buggy: the AOF client reuses the cached slot inside the MULTI, so k0 is duplicated in
the wrong slot on reload (dbsize 3, GET k0 returns "a").
