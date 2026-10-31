Calls `_pyrepl.console.InteractiveColoredConsole().runsource("\x00\n")` with output captured.
Clean: returns False and reports "source code string cannot contain null bytes".
Buggy: `code._showtraceback` compares `len(lines) >= value.lineno` where lineno is None, so
a TypeError escapes runsource (exit status 1).
