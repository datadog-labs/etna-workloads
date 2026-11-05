# Re-introducing the bug: \dX (list extended statistics) removed from psql

The fix commit reverted the addition of `\dX`, so reversing it removes the command. Each hunk below maps to a hunk of fix_impl.patch. Line numbers and signatures were adapted to current code (`listExtendedStats(pattern)` takes no verbose flag now, and help uses `HELP0`).

- src/bin/psql/command.c, exec_command_d: remove `case 'X'`. This is the command.c hunk.
- src/bin/psql/describe.c: delete `listExtendedStats()`. This is the describe.c hunk.
- src/bin/psql/describe.h: delete the `listExtendedStats` prototype. This is the describe.h hunk.
- src/bin/psql/help.c, slashUsage: remove the `\dX` help line. This is the help.c hunk.
- src/bin/psql/tab-complete.in.c, psql_completion: remove `"\\dX"` from the backslash command list, and remove the `\dX*` completion branch. These are the two tab-complete.c hunks.

With these changes `\dX` is an invalid command, so the `\dX` queries in the stats_ext test produce errors instead of the expected output.

Failing oracle case: src/test/regress||stats_ext
