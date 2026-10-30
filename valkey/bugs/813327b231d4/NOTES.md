Sets list-max-listpack-size -1 and list-compress-depth 12, pushes 6000 elements, runs SORT STORE,
then prints DEBUG OBJECT's ql_listpack_max/ql_compressed for the stored list.
Clean: `ql_listpack_max:-1 ql_compressed:1`. Buggy: `ql_listpack_max:-2 ql_compressed:0`
(SORT STORE ignores the configured fill and compress options).
