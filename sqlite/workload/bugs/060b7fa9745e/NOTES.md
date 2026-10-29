Table with INT-affinity column and a NOCASE unique index holds '.1%'. `c0 LIKE '.1%'` should return the row.
The buggy shell only checks for a numeric-looking prefix when the pattern starts with a digit/sign/space, so '.1' slips through and the LIKE range optimization compares against numeric bounds, returning no rows. The clean shell returns `.1%`.
