# Rationale

File: src/src/backend/rewrite/rewriteHandler.c, function RewriteQuery (CTE rewrite loop).
Traces to the fix_impl.patch hunk at RewriteQuery: removes the check that the single Query
resulting from rewriting a data-modifying WITH query is not a utility command (NOTIFY),
and the "DO INSTEAD NOTIFY rules are not supported..." error. A rule rewriting to just NOTIFY
is now stuffed into the CTE node as a utility Query, which is the original bug.

Failing oracle case: src/test/regress||with
