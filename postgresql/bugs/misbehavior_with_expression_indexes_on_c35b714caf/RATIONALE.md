# Rationale

- File: src/backend/catalog/heap.c, function RelationTruncateIndexes.
- Traces to the heap.c hunk of fix.patch. The fix replaced BuildIndexInfo(currentIndex) with BuildDummyIndexInfo(currentIndex). I reverted that call.
- Why this brings the bug back: truncating an index at ON COMMIT DELETE ROWS time builds the real IndexInfo. That evaluates user-defined index expressions and predicates when it shouldn't, so expression indexes on such tables misbehave.
- The BuildDummyIndexInfo and RelationGetDummyIndexExpressions helpers stay in the tree. They are now unused, which is harmless.

Failing oracle cases: src/test/regress||temp
