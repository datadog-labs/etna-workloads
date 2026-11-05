# Rationale

File: src/backend/optimizer/prep/prepjointree.c, function transform_MERGE_to_join().

Traces to the last hunk of fix_impl.patch (the "src IS NOT NULL" addition).
The code is back to its pre-fix behaviour. When there are WHEN NOT MATCHED BY
SOURCE actions, mergeJoinCondition is kept as-is, without the added
"source wholerow IS NOT NULL" qual. The executor rechecks the join condition on
the join output, where source columns are nulled for unmatched rows. A
non-strict condition (e.g. IS NOT DISTINCT FROM) can therefore wrongly
evaluate true.

The earlier hunks of the fix (target/source locals, sourcerti) were left alone.
The current code already has equivalent logic for other uses, and the removed
block was the only thing that depended on them.

Failing oracle case: src/test/regress||merge
