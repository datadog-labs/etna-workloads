# Rationale

Reverts the fix "Use a safer outfuncs/readfuncs representation for BitStrings".

## Hunks
1. `src/backend/nodes/outfuncs.c`, `_outBitString()` — traces to the outfuncs.c hunk of fix.patch.
   Restores `appendStringInfoString(str, node->bsval)` in place of `outToken()`. The lexer does not
   validate bit-string contents (e.g. `b' 0'`), so characters needing escaping (space etc.) are
   written raw and the token is split or misparsed on read-back.
2. `src/backend/nodes/read.c`, `nodeRead()` case `T_BitString` — traces to the read.c hunk.
   Restores the plain memcpy of the token instead of `debackslash()`.

## Extra enabling change (not from fix.patch)
3. `src/include/pg_config_manual.h`: `#define WRITE_READ_PARSE_PLAN_TREES`.
   The `bit` regression test contains invalid literals (`b' 0'`, `x' 0'`), but the raw-tree
   write/read round trip is only exercised when `debug_write_read_parse_plan_trees` is on, which
   the oracle build does not set by default. Without this line the reverted code passes the oracle,
   so it is needed to make the bug observable. It is a deviation from the "every hunk traces to the
   fix" rule.

## Failing oracle case
- src/test/regress||bit  (see the oracle run result below)
