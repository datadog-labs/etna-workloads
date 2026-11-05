# Rationale
- File/function: src/backend/optimizer/prep/prepjointree.c, transform_MERGE_to_join().
- Traces to the single fix_impl.patch hunk, which added a block after the targetList nulling step. I removed that block again. It was identical in today's code, so the removal is an exact reverse.
- The block marked source-relation Vars in mergeJoinCondition, action quals, action targetLists and RETURNING as nullable by the join when the source is on the outer side (JOIN_LEFT/JOIN_FULL). Without it, those Vars have no varnullingrels. Once preprocess_targetlist() adds them to the join's targetlist, this gives the wrong varnullingrels error for MERGE WHEN NOT MATCHED BY SOURCE.

Failing oracle case: src/test/regress||merge
