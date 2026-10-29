Reproducer: INSERT with oversize hex literal in a constant expression.
Clean: "Parse error: hex literal too big". Buggy: assertion failure in sqlite3FinishCoding (ALWAYS(pParse->nErr==0) is false) / abort.
