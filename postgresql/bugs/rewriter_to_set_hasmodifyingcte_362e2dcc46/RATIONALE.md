# Rationale
File: src/backend/rewrite/rewriteHandler.c, function rewriteRuleAction().
Traces to the fix_impl.patch hunk that, after list_concat of the CTE lists, merges
hasRecursive/hasModifyingCTE into sub_action and errors for INSERT...SELECT rule actions
with data-modifying CTEs. (The comment-only hunk was left alone.) I removed that block, so
the rewritten query has a cteList containing data-modifying CTEs but hasModifyingCTE unset
(and hasRecursive not merged), and the unsupported INSERT...SELECT case is no longer rejected.

Failing oracle case: src/test/regress||with
