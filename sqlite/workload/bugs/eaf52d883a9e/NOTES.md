Reproducer: repro.sql binds ?1 and ?2 with `.parameter set`, then runs
`SELECT case when 1 then 99 else ? end + ?;`.

The buggy OP_Variable optimization merges the two unnamed-parameter loads into
one instruction, but the first is skipped by the CASE jump, so the second is
never loaded. Clean shell prints 555. Buggy shell fails an assertion in
sqlite3VdbeExec (memIsValid) and aborts (exit -6).
