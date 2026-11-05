# Rationale

File: src/backend/executor/nodeModifyTable.c, function ExecCheckTupleVisible (modern form of ExecCheckHeapTupleVisible).
Traces to the single hunk in fix_impl.patch. I removed the xmin lookup and the
`TransactionIdIsCurrentTransactionId(xmin)` guard, so the serialization failure is raised
unconditionally. Conflicts against tuples inserted by our own transaction (e.g. conflicting
keys in one INSERT ON CONFLICT DO NOTHING) now fail under REPEATABLE READ/SERIALIZABLE.

Failing oracle cases (verified with a clean, non-overlapping oracle run, status `fail`):
- src/test/isolation||insert-conflict-do-nothing-2
- src/test/regress||insert_conflict
