# Rationale

The fix moved `HoldPinnedPortals()` out of each PL and into SPI's commit and rollback code. I reversed that: the calls are gone from SPI, and nothing in the PLs replaces them. In current code plpgsql, plperl and plpython no longer call it themselves, so none of them hold their portals.

1. `src/backend/executor/spi.c`, `_SPI_commit` and `_SPI_rollback`. These trace to the fix.patch spi.c hunks. I removed the `HoldPinnedPortals()` calls. Without them, pinned portals, such as plpgsql FOR-loop cursors, are not converted to held portals before COMMIT or ROLLBACK. The transaction end then drops them.
2. `src/backend/utils/mmgr/portalmem.c`, `HoldPinnedPortals`. This traces to the portalmem.c hunk. I restored the old order, setting `autoHeld = true` before `HoldPortal(portal)`. The `status != PORTAL_READY` check was already gone from the current code, so only the order changed. If `HoldPortal` fails partway, the portal is left marked auto-held.

I did not edit the PL files. They already have no `HoldPinnedPortals` calls, so the SPI removal is enough to bring the bug back.

Failing oracle case: `src/pl/plpgsql/src||plpgsql_transaction`
