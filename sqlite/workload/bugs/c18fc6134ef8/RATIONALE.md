# Rationale

The fix added JT_RIGHT to the join-type test that rejects WHERE-clause constraints for the right operand of a RIGHT JOIN, in two places (the vtab path `allocateIndexInfo` and the btree path `whereLoopAddBtreeIndex`, tag-20191211-001/002). In 3.54.1 both tests are `(jointype & (JT_LEFT|JT_LTORJ|JT_RIGHT))!=0 && !constraintCompatibleWithOuterJoin(...)`, in `whereLoopAddVirtual`-side code (src/where.c ~line 1456) and `whereLoopAddBtreeIndex` (~line 3306).

Change: removed `|JT_RIGHT` from both conditions, which restores the pre-fix mask `JT_LEFT|JT_LTORJ`. With it gone, WHERE constraints can again drive an index on the right table of a RIGHT JOIN. The automatic-index path (`termCanDriveIndex`) is untouched, as it was not part of the fix.

Oracle failures: join8-18010, join8-18020, join8-18050. These are the added test's indexed variant, which returns a row where the expected result is empty.
