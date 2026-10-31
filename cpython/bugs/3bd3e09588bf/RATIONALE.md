# Rationale

In v3.15.2 the fix's `_PyPegen_checked_future_import` logic lives inside the
`__future__` branch of the import-from action helper in
`Parser/action_helpers.c`. It scans the imported names for `barry_as_FLUFL`
and sets `p->flags |= PyPARSE_BARRY_AS_BDFL` (plus `p->tok->barry_as_bdfl = 1`,
added later). I removed that loop. This reverses the fix hunks that added the
helper to `action_helpers.c` and called it from the `import_from` rule in
`Grammar/python.gram` and `parser.c`. Without the loop, the parser no longer
turns on the flag when it sees the future import. It only honours the flag
if the caller passes it through compile flags.

## Failing oracle case
`test_barry_as_bdfl_look_ma_with_no_compiler_flags` fails. Compiling
`from __future__ import barry_as_FLUFL;2 <> 3` with no compiler flags raises
`SyntaxError: invalid syntax. Maybe you meant '!=' ...`.
