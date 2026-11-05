# Rationale
File: src/backend/parser/parse_clause.c, function flatten_grouping_sets (GROUPING_SET case).
Traces to the fix_impl.patch hunk that added the n1 / list_concat handling for nested GROUPING SETS. I removed it, so a nested GROUPING SETS item is appended as a sublist instead of being concatenated into the outer list. Nested grouping sets are therefore not flattened correctly.
(The comment-only hunk was not reverted.)

Failing oracle case: src/test/regress||groupingsets
