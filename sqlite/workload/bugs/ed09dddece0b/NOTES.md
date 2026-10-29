Reproducer (repro.sql): a one-row table queried with `SELECT b, max(a) FILTER (WHERE b='x') FROM t1;` (filter1-3.1).
Clean shell prints `1|`. Buggy shell aborts with an assertion failure (`memIsValid(&aMem[pOp->p1])`, exit -6),
because the min()/max() FILTER case no longer populates the accumulator registers for the first row.
