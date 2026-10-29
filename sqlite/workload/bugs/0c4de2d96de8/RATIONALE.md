# Rationale

Fix hunk (src/expr.c, sqlite3ExprCodeTarget, TK_FUNCTION): the fix merged the
separate "misuse of aggregate function: %s()" error (pDef->xFunc==0) into the
"unknown function" error. Reversing it restores the earlier, separate message.

In 3.54.1 the aggregate test is `pDef->xFinalize!=0` (aggregates have no xFunc
check any more) and shares the "unknown function" branch. I split it back out in
src/expr.c: an aggregate FuncDef now gets "misuse of aggregate function: %#T()"
and breaks, while pDef==0 / internal-function cases keep "unknown function".

Failing oracle cases (test/table.test): table-16.2, 16.4, 16.5, 16.6, 16.7 — they
expect "unknown function: X()" but get "misuse of aggregate function: X()"
(for DEFAULT expressions using max/avg/count/string_agg).
