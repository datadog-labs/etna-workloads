# Rationale

Hunk: src/backend/commands/operatorcmds.c, RemoveOperatorById(). It traces to the fix_impl.patch hunk in operatorcmds.c.
I removed the `op` variable and the block that called OperatorUpd(operOid, oprcom, oprnegate, true). That block reset the commutator's and negator's back-links. It also re-fetched the tuple for self-commutators.
Without it, DROP OPERATOR leaves dangling oprcom/oprnegate OIDs in the partner operators, which is the original bug. OperatorUpd's isDelete support stays in place but is no longer called for deletes. The pg_operator.c and header hunks are not reverted, because ALTER OPERATOR still uses the new signature.

Failing oracle case: src/test/regress||drop_operator
