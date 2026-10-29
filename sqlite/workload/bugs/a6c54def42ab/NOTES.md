repro.sql selects `rowid` from a view. The clean shell reports "no such column: rowid"
(exit 1). The buggy shell no longer sets TF_NoVisibleRowid in sqlite3CreateView, so it
accepts the query and crashes with a segfault (exit -11).
