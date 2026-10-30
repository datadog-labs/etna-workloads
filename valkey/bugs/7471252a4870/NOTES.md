repro.sh starts a dual-channel primary and replica (diskless sync), loads 100 keys, resets stats,
attaches the replica, waits for it to be online, then checks total_net_repl_output_bytes > 1000.
Clean: prints "repl bytes > 1000". Buggy: the RDB child no longer reports its bytes, so it prints "repl bytes too low".
