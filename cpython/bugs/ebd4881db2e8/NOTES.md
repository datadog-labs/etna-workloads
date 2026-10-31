Calls SqliteInteractiveConsole.runsource() with dot commands that have extra whitespace (".version ", ". version"), an unknown command, ".", and blank input.
Clean: runs/handles them (prints version, error for unknown, returns False). Buggy: only exact ".version" matches, so these are treated as incomplete SQL and runsource returns True with no output.
