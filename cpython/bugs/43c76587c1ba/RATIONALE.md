# Rationale

Fix hunk reversed (Objects/dictobject.c, `insertdict()`): the fix changed the
insert condition from `ix == DKIX_EMPTY` to `old_value == NULL`, because a
split table can hold a key (ix >= 0) with no value in this dict. In v3.15.2
`old_value` was already initialised to NULL, so only the condition needed
reverting: it is back to `if (ix == DKIX_EMPTY)` and the NOTE comment is
removed. A non-str key matching a shared-table key with no value in the dict
then falls through to `replace_value()` with `old_value == NULL`.

Oracle: `test_split_table_insert_with_str_subclass` fails, and
`test_split_table_update_with_str_subclass` fails too. The run crashes
(incomplete run), so the later tests in test_dict are also counted as failing.
