repro.sql: opens the corrupt FTS3 db from fts3corrupt4-30.0 via .open --hexdb, runs UPDATE t1 SET b=a then the matchinfo query (30.2).
Clean: 'database disk image is malformed' (exit 1). Buggy: assertion failure in fts3PutDeltaVarint3 (*pbFirst==0 || iWrite>0), abort.
