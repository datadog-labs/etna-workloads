# Rationale

## src/backend/optimizer/util/appendinfo.c, make_inh_translation_list()
Traces to the fix.patch hunks in prepunion.c make_inh_translation_list(), which
removed the `att->attinhcount != 0` conditions. The function has since moved to
appendinfo.c and now does a by-name syscache lookup instead of a loop, so the
check is re-added in the two places that find the child column:
1. The "guess the next column" condition treats a child column with
   attinhcount == 0 as a non-match.
2. The syscache lookup result is rejected, raising "could not find inherited
   attribute", when attinhcount == 0.

A SELECT on an inheritance tree that runs concurrently with ALTER TABLE ... NO
INHERIT locks a just-disinherited child whose columns now have attinhcount = 0.
The translation list then fails with "could not find inherited attribute"
instead of succeeding.

## Failing oracle cases
- src/test/isolation||alter-table-4
