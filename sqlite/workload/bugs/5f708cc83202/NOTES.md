repro.sql: creates an fts5 table with one row ('A B C', 'D E F') and calls snippet() on column 1 with a 1-token window, matching a term in the other column.
Clean prints `D...`; buggy prints `...` because iRangeEnd isn't initialised to -1 and the range-0 case is treated as "no range" (the D token is dropped).
