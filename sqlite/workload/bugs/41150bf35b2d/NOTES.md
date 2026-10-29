`repro.sql` runs two identical `json_group_array(v) OVER w` window functions (SQLITE_SUBTYPE functions) in one query over a two-row table.

The clean shell returns `["one","two"]|["one","two"]` for both rows. The buggy shell returns `["one","one"]|["one","two"]`. With the injected bug, `windowAggStep` rewrites OP_Column cursors by comparing against `pWin->iEphCsr` instead of `pMWin->iEphCsr`, so the first function reads the wrong column.
