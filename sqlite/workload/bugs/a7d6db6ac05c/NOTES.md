repro.sql compares likely/unlikely/likelihood(CAST(1 AS INT)) with '1'.
These functions must have no affinity, so the comparison is 0 (INTEGER vs TEXT).
The buggy shell lets the INT affinity through, so it applies it to '1' and returns 1.
