# Rationale
- File: src/backend/utils/sort/tuplesortvariants.c, function tuplesort_begin_cluster (code moved here from tuplesort.c).
- Traces to the single fix.patch hunk in tuplesort_begin_cluster: the scan slot for evaluating index expressions goes back from TTSOpsHeapTuple to TTSOpsVirtual.
- Why it restores the bug: the slot is filled with heap tuples when CLUSTER evaluates expression indexes. A virtual slot is the wrong slot type for that, so CLUSTER on expression indexes misbehaves.

Failing oracle case: src/test/regress||cluster
