Reproducer (`repro.sql`): a NOCASE text column with a DESC index (t4x) holds a mix of text and blob values; `LIKE 'ab%'` is queried with ORDER BY x, x DESC and x ASC (like3-4.0 to 4.2).

Clean shell: text rows come before blobs for ASC and blobs before text for DESC.
Buggy shell: the LIKE-optimization loop counter is set wrong for DESC indexes, so the text and blob groups come out swapped in all three queries.
