# Rationale

## src/backend/utils/adt/ruleutils.c, appendContextKeyword()
Traces to the fix.patch hunk in `appendContextKeyword` that added
`removeStringInfoSpaces(buf)` before appending the newline. I removed that call
(and its comments), so pretty-printed output once again keeps trailing spaces
that precede a line break (e.g. "SELECT a, " + newline). The other fix hunks
(get_target_list / get_from_clause) now only matter for the same trailing space
case and were left unchanged to keep the change minimal; the helper function is
still used by them.

## Failing oracle cases (8/8)
aggregates, create_view, matview, polymorphism, rules, triggers,
updatable_views, with
