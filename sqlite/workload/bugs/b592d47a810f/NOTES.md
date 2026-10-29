repro.sql (from skipscan1-8.1): a WITHOUT ROWID table with a faked sqlite_stat1
makes skip-scan attractive; the query ORs `y='AB' AND x<=4` with `y='EF' AND x=5`.
Clean shell prints `1|AB`. The buggy shell (nLTerm not restored in
whereLoopAddBtreeIndex, so skip-scan is tried after a non-equality term) hits
assertion `pTerm!=0` in codeAllEqualityTerms and aborts.
