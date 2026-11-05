# Rationale
Hunk: src/backend/catalog/index.c, index_update_stats(). Traces to the fix hunk that adds the autovacuum block (the `AutoVacuumingActive()` check, the per-table `autovacuum.enabled` check, and `update_stats = false`). In the current code that block sits inside a relkind test. The reversal removes the whole block. CREATE INDEX then always updates table relstats, even when autovacuum is off globally or for the table, so it overwrites restored stats.

The `#include "postmaster/autovacuum.h"` is left in place. It is harmless, and the fix's include hunk is not part of the logic.

Failing oracle case: src/test/regress||stats_import
