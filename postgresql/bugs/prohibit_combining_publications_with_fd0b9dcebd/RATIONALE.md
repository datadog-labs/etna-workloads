# Rationale

Both hunks remove the "cannot use different column lists" error that the fix added.

1. `src/backend/commands/subscriptioncmds.c`, `fetch_table_list`.
   This traces to the fix.patch hunk that adds the `list_member(tablelist, rv)` check with its ERROR.
   I reverted it to an unconditional `lappend`. CREATE/REFRESH SUBSCRIPTION no longer rejects a table
   that appears with different column lists in different publications.
2. `src/backend/replication/pgoutput/pgoutput.c`, `pgoutput_column_list_init`.
   This traces to the fix.patch hunk that adds the `!bms_equal(entry->columns, cols)` ERROR.
   I removed that branch, so publications with differing column lists are no longer detected at
   replication time. The first publication's list is used silently.

Failing oracle case: `src/test/subscription|t/031_column_list.pl|different column lists detected`.
