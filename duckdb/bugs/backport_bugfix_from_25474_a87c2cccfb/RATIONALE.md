# Rationale
File: src/parser/peg/transformer/transform_alter.cpp, PEGTransformerFactory::TransformAddColumnEntry.
Traces to the fix's added branches throwing "Adding columns with ... constraints is not supported yet".
In today's code UNIQUE (non-PK) is now supported, so only the PRIMARY KEY (UNIQUE+pk), CHECK and FOREIGN KEY
throwing branches remain; I removed them so those constraints are silently ignored on ADD COLUMN, as before the fix.

Oracle result:
FAIL test/sql/alter/add_col/test_add_col_constraints.test
  test_add_col_constraints.test:11 :: Query unexpectedly succeeded!
  ALTER TABLE t1 ADD COLUMN j INTEGER PRIMARY KEY;
1 of 1 oracle units fail
