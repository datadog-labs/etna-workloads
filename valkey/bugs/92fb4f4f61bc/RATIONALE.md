# Rationale

9.0.7 already contains the fix's structure (movablekeys computed in `populateCommandLegacyRangeSpec`, `populateCommandMovableKeys` gone). The bug is the old rule that any command with a `getkeys_proc` is movablekeys.

## Change (src/server.c, `populateCommandLegacyRangeSpec`)
Reverses the fix hunk that replaced the `cmd->getkeys_proc || (flags & CMD_MODULE_GETKEYS)` test (in the removed `populateCommandMovableKeys`) with a module-only `CMD_MODULE_GETKEYS` check. The code is now `if (c->getkeys_proc || (c->flags & CMD_MODULE_GETKEYS)) c->flags |= CMD_MOVABLE_KEYS;`, which is the same condition as before the fix. SET and BITFIELD have a `getkeys_proc` (added in #10148), so they are wrongly marked movablekeys again.

## Oracle failures
tests/unit/introspection-2.tcl: "SET command will not be marked with movablekeys" and "BITFIELD command will not be marked with movablekeys" fail with `Expected 'write denyoom movablekeys' to not match '*movablekeys*'`.
