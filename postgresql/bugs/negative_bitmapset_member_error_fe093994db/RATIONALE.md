# Rationale

## src/backend/optimizer/plan/analyzejoins.c, remove_rel_from_query()
Traces to the single hunk in fix.patch (the placeholder-removal condition in remove_rel_from_query).
The current code guards the condition with `sjinfo != NULL &&`, so self-join elimination
(sjinfo == NULL) never reaches the ojrelid test. I removed that guard and test
`bms_is_member(sjinfo ? sjinfo->ojrelid : -1, ph_eval_at)`. With sjinfo == NULL (SJE),
bms_is_member now gets a negative value and raises "negative bitmapset member not allowed".
That is the bug the fix removed.

## Failing oracle cases
- src/test/regress||join
