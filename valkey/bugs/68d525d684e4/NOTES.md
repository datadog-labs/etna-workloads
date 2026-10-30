Reproducer: starts a server with AOF + RDB preamble, runs BGREWRITEAOF (base file starts with `VALKEY`),
then runs valkey-check-aof (the server binary symlinked under that name) on the manifest.
Clean: base checked as "RDB format", all files valid, exit 0.
Buggy: base misdetected as "RESP format", check fails, exit 1.
