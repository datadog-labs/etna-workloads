Inserts into a 4-column table with only column `a` listed, from a compound SELECT with ORDER BY.
The buggy shell copies the wrong number of registers in the output subroutine (pDest->nSdst instead of pIn->nSdst).
Clean prints `123||c|` and `456||c|`; the buggy shell gives different rows (or fails an assertion).
