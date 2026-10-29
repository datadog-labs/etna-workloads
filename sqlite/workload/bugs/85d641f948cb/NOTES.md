`SELECT * FROM t ORDER BY 1, 0;` should fail with "2nd ORDER BY term out of range - should be between 1 and 2".
The buggy check `(iCol & ~0xffff)!=0` lets 0 through, so the buggy shell returns the row instead of the error. The clean shell reports the error.
