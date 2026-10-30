Reproducer: AOF-enabled server with stream-node-max-entries 100; 100 XADDs, then `XADD MAXLEN ~ 100` (trims nothing), set node-max-entries 1, `DEBUG LOADAOF`, print XLEN.
Clean: 101 after reload. Buggy: 100, because the approx-trim argument is only rewritten when something was trimmed, so the AOF keeps `~ 100` and re-trims under the smaller node size.
