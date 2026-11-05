# Rationale

Hunk: `src/backend/rewrite/rewriteHandler.c`, `rewriteValuesRTE()`.

Traces to the fix.patch hunk that adds the `isAutoUpdatableView` detection and the "Leave the value untouched" branch. In the current code, the detection block ends with `if (!found) isAutoUpdatableView = true;`. I changed that to `false`.

Effect: DEFAULT items in multi-row VALUES for an auto-updatable view with no view-level default are again replaced with explicit NULL. They are no longer left for the base relation's default to fill in when the query is rewritten onto the base table. This is the original bug.

Failing oracle case: `src/test/regress||updatable_views`
