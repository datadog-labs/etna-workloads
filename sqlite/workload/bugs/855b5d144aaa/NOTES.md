Reproducer (repro.sql): the subquery2-5.1 case. A correlated scalar subquery with
ORDER BY y, z reuses an ephemeral sorter table via a second OP_OpenEphemeral.
The buggy build doesn't reset the sequence counter or mark the cache stale on reopen.

Clean shell prints ALFKI and ANATR. Buggy shell prints only ALFKI, so the second row is missing.
