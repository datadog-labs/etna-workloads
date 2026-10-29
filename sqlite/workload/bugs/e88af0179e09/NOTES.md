Creates an fts4 table with languageid, inserts rows, then in a transaction moves them to lid=1
and runs 'integrity-check' before COMMIT. The buggy shell reports a spurious corruption error
(pending-terms data of a different langid is read); the clean shell succeeds silently.
