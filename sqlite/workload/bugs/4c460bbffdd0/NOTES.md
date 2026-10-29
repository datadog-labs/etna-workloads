repro.sql creates a table and a trigger whose body has a syntax error (`LIMIT 1,#1`).
Clean shell: reports `near "#1": syntax error`, exit 1.
Buggy shell: the parser still allocates a Trigger step after the error, so it aborts with
assertion `dupedExprStructSize: p->pRight==0` (exit -6).
