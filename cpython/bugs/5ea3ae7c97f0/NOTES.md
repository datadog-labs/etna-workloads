Runs `python -qm asyncio` with PYTHONSTARTUP pointing at a script containing `1/0`, feeding a print statement on stdin.
Clean: the startup traceback (ZeroDivisionError) is shown and the REPL continues, running the user code.
Buggy: the exception from the startup script is not handled, so the REPL dies and no traceback or user output appears (the filtered output is just the exit status).
