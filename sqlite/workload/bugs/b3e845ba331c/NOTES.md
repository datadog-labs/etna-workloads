Reproducer (repro.sql) is fts5simple3-4.6: a phrase query `'ab + xyz'` where the first token matches a row but the second matches none.
Clean shell: no output, exit 0. Buggy shell: assertion `pIter->base.bEof==0` failed in fts5MultiIterNext (abort, exit -6).
