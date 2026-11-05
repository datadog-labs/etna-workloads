# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function remove_rel_from_restrictinfo().

Traces to the fix.patch hunk that added the "If it's an OR, recurse to clean up sub-clauses" block (and the new helper function). In today's code the helper already exists, so I removed that OR-recursion block. The function now cleans relid/ojrelid only from the top-level RestrictInfo's relid sets. The sub-RestrictInfos inside an OR clause keep stale references to the removed rel/outer join, which is the original bug.

Failing oracle case: src/test/regress||join
