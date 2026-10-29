# Rationale

Fix: bound the linear-probing loops over fts5 tombstone hash pages by the slot count (`nCollide`), so corrupt (full) pages cannot cause an infinite loop.

Changes in `ext/fts5/fts5_index.c` (the `const`/`TOMBSTONE_NSLOT` edits in the fix are cosmetic and left as is):

- `fts5IndexTombstoneQuery`: removed `int nCollide = nSlot;` and both `if( nCollide--==0 ) break;` guards (u32 and u64 loops). Reverses the first fix hunk; the probe loop is unbounded again, as before the fix.
- `fts5IndexTombstoneAddToPage`: removed `int nCollide = nSlot;` and both `if( nCollide--==0 ) return 0;` guards. Reverses the second fix hunk; the insert probe loops are unbounded again.

Oracle: fts5contentless3.test overwrites the last ft_data tombstone page with a completely full hash page (no zero slots). Querying (1.3/1.4, `SELECT ... FROM ft('two')`) or inserting (1.2/1.5, `DELETE`) then loops forever. `./check.sh` did not finish (hung for >10 minutes); I killed it, so the oracle shows as a hang/timeout rather than a clean assertion failure.
