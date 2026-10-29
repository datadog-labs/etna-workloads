Table with a BLOB/no-affinity UNIQUE column holding -1; `c0 GLOB '-*'` should return -1.
The buggy shell applies the LIKE/GLOB range optimization with prefix "-" (the fix skips it
for non-text columns), so the index range scan misses the row and returns nothing.
