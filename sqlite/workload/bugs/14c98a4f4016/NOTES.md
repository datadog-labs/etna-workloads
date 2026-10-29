Reproducer (repro.sql) is the in6-3.100 case: a LEFT JOIN whose ON clause uses an IN operator on an indexed column (`d IN (2,3,4)`) with `b=NULL`.

Clean shell: prints `0|||`, exit 0.
Buggy shell: aborts with `Assertion 'memIsValid(&r.aMem[ii])' failed` in sqlite3VdbeExec (exit 134). OP_IfNoHope is emitted before OP_IfNotOpen, so it reads an uninitialized register.
