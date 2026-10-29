# Rationale

Fix: FTS3 `NEAR/N` accepted only a single digit before the fix (range > 9 broke); the fix
made nNear a `short int` and parsed all digits (max 32767). The rest of the fix hunks are
renames (pSegment->zSegment), which are not behavioural.

## Change: ext/fts3/fts3_expr.c (`getNextString`/keyword parse in `getNextNode`)
Reverses the "parse all digits" loop of the fix's `NEAR/` hunk. The modern code uses
`sqlite3Fts3ReadInt()` to read every digit; I replaced it with reading exactly one digit
(`nNear = zInput[5]-'0'; nKey += 2;`), the pre-fix behaviour. `NEAR/10` then fails the
"next byte is a delimiter" keyword check and is treated as an ordinary token, so the query
no longer matches as NEAR with range 10+. The nNear type-width hunk has no counterpart
(nNear is already an `int`).

## Oracle failures
fts3near-5.4, fts3near-5.6, fts3near-6.5 return `{}` instead of the expected rows
(queries using NEAR/ with multi-digit ranges).
