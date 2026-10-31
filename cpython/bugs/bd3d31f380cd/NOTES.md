Sets `sys.excepthook = 1` (not callable) and feeds `1/0`, `a = 123`, `print(a)` to a `code.InteractiveConsole`.
Clean: the failing hook is reported ("Error in sys.excepthook:" ... "Original exception was:"), the console keeps going and prints `done`.
Buggy: the TypeError from the hook escapes `push()`, crashing the REPL; `done` is never printed.
