repro.sql is delete4.test case 5.0 translated to SQL. It builds a 1024-byte-page table with an index, turns on `reverse_unordered_selects`, then runs `DELETE FROM t1 WHERE b=2` and selects the rows with b=2.

- Clean shell: the SELECT returns nothing, so the delete removed every row.
- Buggy shell: the SELECT returns `12`, a row the DELETE missed. In the buggy build, sqlite3BtreeDelete() saves the cursor key after it has already moved the cursor off a non-leaf cell.
