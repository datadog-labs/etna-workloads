repro.sh builds ext/misc/eval.c from ../tree (needs gcc) as a loadable extension defining eval(X), which runs SQL on
the calling connection. A SELECT with a correlated NOT EXISTS over t2 calls
eval('CREATE INDEX ...') on the row a=3, mirroring tkt-c694113d5.100 (the harness does the
CREATE INDEX from inside the db eval loop; plain SQL can't).

clean: all four rows (1,2,3,4) are returned, exit 0.
buggy: CREATE INDEX emits OP_Expire without P2=1, so the running statement is expired
immediately; the next OP_OpenRead fails with "abort due to ROLLBACK" after row 3, exit 1.
