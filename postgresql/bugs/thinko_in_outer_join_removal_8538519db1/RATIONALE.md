# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function join_is_removable().

Traces to the fix.patch hunks that changed the attr_needed check and the PHV ph_needed check from `joinrelids` to `inputrelids`.
I reverted both comparisons to use `joinrelids`, which includes the OJ's own relid:
- `bms_is_subset(innerrel->attr_needed[attroff], joinrelids)`
- `bms_is_subset(phinfo->ph_needed, joinrelids)`

Effect: inner-rel attributes (or PHVs) needed only by conditions pushed down to the outer join itself have the OJ relid in attr_needed/ph_needed. They now count as "not needed above the join". The join is wrongly removed, so the query is planned or run incorrectly.

Failing oracle case: src/test/regress||join
