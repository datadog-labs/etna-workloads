# Rationale

**File/function:** src/backend/tcop/utility.c, `ProcessUtilitySlow` (T_IndexStmt case).

**Traces to:** the fix_impl.patch hunk that added, in the partition-verification loop, an up-front ereport(ERROR) for foreign-table partitions ("cannot create ... on partitioned table", detail "contains partitions that are foreign tables"). In today's code that check is limited to unique/primary indexes. I removed it.

**Why this brings the bug back:** CREATE [UNIQUE] INDEX on a partitioned table with foreign partitions is no longer rejected up front. The error is not raised until DefineIndex reaches the foreign partition, after other indexes may already have been built. That is the "build some indexes only to fail later" behaviour the fix removed.

**Failing oracle case:** src/test/regress||foreign_data
