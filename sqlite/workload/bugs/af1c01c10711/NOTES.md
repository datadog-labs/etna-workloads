Reproducer (`repro.sql`): the conflict2-14.1 case. REPLACE into a table with a TEXT PRIMARY KEY NOT NULL plus a UNIQUE index on (x,y) deletes the conflicting row's index entry via OP_IdxDelete.

The buggy shell sets UNPACKED_PREFIX_MATCH there. The clean shell prints `ok`, `alpha|gamma`, `alpha|gamma|1`. The buggy shell fails with "database disk image is malformed" and leaves the old row (`alpha|beta`), with exit status 1.
