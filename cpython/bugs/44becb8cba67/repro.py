import io, contextlib
from _pyrepl.console import InteractiveColoredConsole
console = InteractiveColoredConsole()
f = io.StringIO()
with contextlib.redirect_stdout(f), contextlib.redirect_stderr(f):
    result = console.runsource("\x00\n")
print(repr(result))
print("null bytes" in f.getvalue())
