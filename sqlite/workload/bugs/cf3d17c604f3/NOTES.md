repro.sh builds a 64K-page db with two rows, then zeroes the 2nd cell pointer and the cell-content-start field of the root page (page 2), and runs `DELETE FROM t1 WHERE a=0`.
Clean: "database disk image is malformed" (exit 1). Buggy: assertion failure in freeSpace() (`iStart>=hdrOffset+6+childPtrSize`), abort, exit 134.
