# Rationale

Fix (ticket #3944) changed `sqlite3AuthRead` so that a NEW/OLD reference seen
where a table list is also present (`SELECT new.x FROM t`, or `WHERE NEW.x=0`
in a trigger's UPDATE) is looked up as a trigger pseudo-table instead of only
searching `pTabList`.

In 3.54.1 that logic is the `pExpr->op==TK_TRIGGER` branch in
`tree/src/auth.c`. I changed the condition to
`pExpr->op==TK_TRIGGER && pTabList==0`, which restores the pre-fix rule:
use the trigger table only when there is no table list. With a table list
the code searches only `pTabList`, finds no cursor match for the NEW/OLD
cursor, leaves `pTab==0` and returns, so no SQLITE_READ is authorized.
(The pre-fix code instead ran off the end of the list; today's loop is
bounded, so the symptom is a missing auth callback rather than a bad read.)

## Oracle
`auth-5.3.2` fails: expected
`SQLITE_INSERT ... SQLITE_UPDATE t5 x main t5_tr1 SQLITE_READ t5 x main t5_tr1`,
got the list without the final SQLITE_READ.
