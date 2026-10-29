# Rationale

Hunk reversed: src/update.c, sqlite3Update(), the multi-row one-pass condition.
The fix added `(sNC.ncFlags & NC_Subquery)==0` (3.54.1 spells it
`(pWhere==0 || !ExprHasProperty(pWhere, EP_Subquery))`) to the test that
allows WHERE_ONEPASS_MULTIROW. I removed that clause, so an UPDATE whose WHERE
clause contains a subquery can again use multi-row one-pass. A subquery behind
a short-circuit operator can then be evaluated after rows were already updated.
The "(5) There are subqueries in the WHERE clause" comment line is left in place.

Failing oracle cases: update-21.4 (expected `6 -54 100 NULL`, got
`100 NULL 100 -54`) and update-22.0. The corruptL-15.x cases did not
fail in the check output I saw.
