Reproducer (repro.sql): a REAL-affinity column holds 836627109860825358, is indexed, and is queried with `a = CAST(836627109860825358 AS REAL)`.
Clean shell returns `8.36`. Buggy shell returns no rows, because the index record stores the value as an 8-byte integer instead of a REAL, so the index lookup misses it (intreal-2.2).
