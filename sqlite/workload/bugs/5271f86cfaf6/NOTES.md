repro.sql builds a small fts5 table, then (with defensive mode off) overwrites the
x1_data structure record with one whose segment pgnoLast is 0x7FFFFFFF, and queries it.
Clean: `fts5: corrupt structure record for table "x1"`.
Buggy: `fts5: corruption found reading blob 412316860417 from table "x1"` (the
page-number bound check in fts5StructureDecode is missing, so the error comes later).
