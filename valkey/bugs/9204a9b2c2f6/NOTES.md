Pushes one element to a list, then runs `LPOS l b RANK 5 COUNT 10` (RANK greater than matches).
Clean: empty array reply. Buggy: deferred array length is `matches-rank+1` = -4, an invalid reply (`*-4`), which breaks the client/connection.
