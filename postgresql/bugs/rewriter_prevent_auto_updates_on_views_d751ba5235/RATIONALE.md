# Rationale

File: src/backend/rewrite/rewriteHandler.c, function RewriteQuery (hunk 2 of fix_impl.patch; the execMain.c hunk is comment-only).

The fix added `qual_product != NULL` handling to the auto-updatable view branch. Without it, the branch ran even when a conditional INSTEAD rule existed. The fix's error block ("Views with conditional DO INSTEAD rules are not automatically updatable") is now removed. The condition is back to `!instead && qual_product == NULL && ...`. A view with only a conditional INSTEAD rule therefore skips auto-update. It falls through to the executor, which no longer reports the clear rewriter error.

Failing oracle case: src/test/regress||updatable_views
