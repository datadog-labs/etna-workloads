Reproducer: `SELECT t42.rowid FROM t42, t41` where t42 is a normal table and t41 is WITHOUT ROWID (the last FROM term).
The buggy shell checks rowid visibility against the last FROM-clause table instead of the matched table, so it fails with an error (or assertion) instead of returning 1.
