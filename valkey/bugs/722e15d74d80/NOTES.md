repro.sh starts a server with AOF, writes `foo`, stops it, appends a truncated MULTI/SET/partial-EXEC to the incr AOF, and restarts with aof-load-truncated yes. It then sets `baz`, restarts again and reads the keys.
Clean: the incomplete transaction is cut before MULTI, so `baz` survives the second restart.
Buggy: the AOF is truncated at the wrong offset (valid_up_to is wrong), so the second restart does not come back with the data (the later gets fail to connect or return nothing).
