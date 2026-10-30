repro.sh starts a server with a config file, sets `maxmemory 9223372036854775808` (> LLONG_MAX), runs CONFIG REWRITE and prints the maxmemory line of the file.
Clean: `maxmemory 8589934592gb`. Buggy: `maxmemory -8589934592gb` (signed overflow in rewriteConfigFormatMemory).
