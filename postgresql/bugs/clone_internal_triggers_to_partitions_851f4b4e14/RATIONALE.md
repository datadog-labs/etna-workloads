# Rationale

Hunk: src/backend/commands/tablecmds.c, CloneRowTriggersToPartition(). Traces to the single fix_impl.patch hunk, which added the skip-tgisinternal check.
I removed the equivalent check (if (trigForm->tgisinternal) continue;) from current code, so internal triggers (e.g. RI triggers) get cloned to partitions as ordinary triggers, duplicating those the constraint cloning code creates.

Failing oracle case: src/test/regress||triggers
