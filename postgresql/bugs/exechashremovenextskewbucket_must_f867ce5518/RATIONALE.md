# Rationale

File/function: src/backend/executor/nodeHash.c, ExecHashRemoveNextSkewBucket (batchno == curbatch branch).
Traces to the single fix_impl.patch hunk. The fix copies the skew tuple into dense storage
(dense_alloc + memcpy + pfree) before linking it into the main bucket. I removed the copy and
link the skew-allocated tuple directly into buckets.unshared[bucketno]. That tuple is not in
the dense chunks, so ExecHashIncreaseNumBatches (which scans the chunks) never finds it: tuples are lost or mishandled.

Failing oracle case: src/test/regress||join
