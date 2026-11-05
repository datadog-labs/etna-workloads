# Rationale
File: src/backend/commands/tablecmds.c, function MergeAttributes (duplicate-name loop over `columns`).

Traces to the fix.patch hunk in MergeAttributes that made merging conditional on `is_from_parent`
and otherwise raised "column specified more than once". The is_from_parent field no longer exists:
the code now has an explicit duplicate-check loop where only `is_from_type` columns merge and all
others error. I re-expressed the bug by also merging (instead of erroring) when `is_partition`,
so a partitioned-table column specified twice is silently merged rather than rejected.

Failing oracle case: src/test/regress||create_table
