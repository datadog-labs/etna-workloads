repro.sql: a trigger body contains `sum() FILTER (WHERE (SELECT sum() FILTER (WHERE 0)) AND a)`, with `sum` called with no args (unregistered aggregate). Then `ALTER TABLE t1 RENAME TO t1x`.
Clean: `error in trigger AFTER: no such column: a`, exit 1.
Buggy: assertion failure `selectAddSubqueryTypeInfo: (p->selFlags & SF_Resolved)`, abort (exit 134).
