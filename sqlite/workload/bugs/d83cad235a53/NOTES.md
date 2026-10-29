repro.sql builds an 18-column table with an index on each column, inserts one row (c0=1, c16=1), and selects with an 18-term OR clause.
Clean: the row is returned once. Buggy: it is returned twice, because the RowSet batch number is truncated to u8 (`iSet & 0xf`), so with 17+ OR terms batch 16 aliases batch 0 and the duplicate-suppression test goes wrong.
