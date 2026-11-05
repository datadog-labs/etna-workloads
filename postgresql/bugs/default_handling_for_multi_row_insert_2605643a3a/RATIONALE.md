# Rationale

File: src/backend/rewrite/rewriteHandler.c, function RewriteQuery(), INSERT / VALUES RTE detection.

Traces to the fix.patch hunk that replaced the single-element fromlist check with a loop over the fromlist
that skips RTEs with rtindex <= orig_rt_length (already-processed VALUES RTEs of the original query).
I restored the old logic: only look at the VALUES RTE when the fromlist has exactly one RangeTblRef, with no
orig_rt_length skip. The orig_rt_length parameter is still passed around but no longer used.

Effect: for multi-row INSERT with rules, product queries (whose fromlist includes the original, already
processed VALUES RTE plus others) are mishandled: DEFAULT items are not handled / are handled wrongly.

Failing oracle case: src/test/regress||rules
