Creates an fts4 table with prefix=1, inserts a row and runs 'optimize' in the same
transaction, then runs 'integrity-check'. Without the flush of pending terms before
optimize, the prefix index is lost, so the buggy shell reports a corrupt-vtab error
on integrity-check while the clean shell succeeds silently.
