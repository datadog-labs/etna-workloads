# Rationale

File: src/backend/utils/adt/selfuncs.c, function estimate_multivariate_ndistinct (the code was refactored since the fix, so the three guards live in different places than in fix_impl.patch).

Removed the three `AttrNumberIsForUserDefinedAttr(attnum)` guards on simple Vars. Each one traces to a fix_impl.patch hunk that added a check to skip system attributes:
1. Counting shared vars per statistics object (`nshared_vars` loop). This traces to the first hunk, which skips system attributes when building `attnums`. Without the guard, a negative attnum reaches `bms_is_member(attnum, info->keys)`, which errors on negative members.
2. Matching Vars against the chosen statistics object. This also traces to the first hunk. Without the guard, system attributes are added to the matched set and checked with `bms_is_member`.
3. Building the leftover varinfo list. This traces to the second hunk, which skips system attributes when filtering out matched vars.

Together these bring back the bug: GROUP BY on a system column (such as ctid) plus user columns covered by ndistinct stats hits negative bitmapset members. The planner then fails or misestimates.

Failing oracle case: src/test/regress||stats_ext
