repro.sql: attaches an in-memory db, opens a transaction (BEGIN) and reads aux.t2, which leaves
a read transaction open on aux, then runs DETACH aux.
Clean: "Error near line 6: database aux is locked", exit 1.
Buggy: DETACH succeeds silently (the check only refuses when a write txn is active), exit 0.
