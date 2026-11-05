# Rationale

File/function: src/backend/utils/adt/ruleutils.c, set_using_names().

Traces to the fix.patch hunk that adds, in set_using_names(), the block
"Mark child deparse_columns structs with correct parentUsing info"
(`leftcolinfo->parentUsing = parentUsing; rightcolinfo->parentUsing = parentUsing;`).
I removed those two assignments. The parentUsing list is still built and passed
down, but is never stored in the child RTEs' deparse_columns. So colname_is_unique()
and the names hash no longer see the parent-join USING names. A column added to the
side of a sub-join that did not provide the USING column can then keep the USING
name, and the deparsed view is ambiguous when re-parsed.

Failing oracle case: src/test/regress||create_view
