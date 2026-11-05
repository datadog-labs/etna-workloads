# Rationale

File: src/backend/commands/createas.c, function ExecCreateTableAs. All hunks trace to the createas.c hunks of fix_impl.patch, reversed.

- Removed the `do_refresh` variable and the block that forced `into->skipData = true` for matviews.
- Removed the `RefreshMatViewByOid(...)` call after create_ctas_nodata, and the `Assert(!is_matview)` in the data-loading branch.

Effect: CREATE MATERIALIZED VIEW (with data) again populates the view through the ordinary CTAS executor path, not REFRESH. It no longer runs with SECURITY_RESTRICTED_OPERATION or the restricted search_path that REFRESH uses. A matview can then be created that a later refresh can't handle, which is the original bug. The matview.c refactor is left in place and is simply unused by CREATE.

Failing oracle case: src/test/regress||namespace
