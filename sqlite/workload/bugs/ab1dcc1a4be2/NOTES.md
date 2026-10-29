repro.sql builds t10(a,b) with 100000 rows (a=i/10, b=i%10, inserted in b order), sets cache_size=5 so
the sorter spills to multiple PMAs, then stores `SELECT a,b FROM t10 ORDER BY a` and compares it with
the (a,b)-ordered result (sort-13.3). The sort must be stable, so there should be 0 mismatches.
Clean shell prints 0; buggy shell (merge tie-break `iRes<=0`) prints 40 mismatched rows.
