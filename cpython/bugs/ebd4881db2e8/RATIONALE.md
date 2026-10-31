# Rationale

Single file changed: `tree/Lib/sqlite3/__main__.py`, `SqliteInteractiveConsole.runsource`.

The fix (gh-133439) replaced an exact-match `match source:` on `.version`/`.help`/`.quit`
with: an early return for empty/whitespace-only source, and dot-command handling on
`source[1:].strip()` (plus an error for unknown commands). I restored the pre-fix structure:
exact `match source:` with `case ".version"`, `".help"`, `".quit"`, and a `case _` that
falls through to `complete_statement`/`execute`. The current help text, theme and
`execute(..., theme=theme)` are kept, so only the fixed logic is reverted.

Resulting bug: `.version ` (trailing space) or `. version` are not recognised as dot commands
and are treated as an incomplete SQL statement (PS2 prompt); unknown dot commands and
`.` produce no error and wait for more input; empty/blank lines are buffered as incomplete
input rather than returning immediately.

Expected failing oracle cases: `test_interact_empty_source`,
`test_interact_dot_commands_unknown`, `test_interact_dot_commands_empty`,
`test_interact_dot_commands_with_whitespaces`.
