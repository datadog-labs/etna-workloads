# Rationale

File: src/backend/rewrite/rewriteHandler.c, function process_matched_tle (traces to the single fix_impl.patch file; all three hunks).

1. Removed the `CoerceToDomain *coerce_expr = NULL;` declaration (hunk 1).
2. Removed the block that strips matching CoerceToDomain nodes from src_expr/prior_expr (hunk 2). Without it, two assignments to subfields/elements of a domain-typed column see CoerceToDomain as the expression, get_assignment_input returns NULL, and the "multiple assignments to same column" error is raised again.
3. Removed the block that re-wraps the merged expression in CoerceToDomain (hunk 3).

Failing oracle case: src/test/regress||domain
