import io, contextlib
from _pyrepl.console import InteractiveColoredConsole

console = InteractiveColoredConsole()
f = io.StringIO()
with contextlib.redirect_stdout(f):
    console.runsource("from __future__ import barry_as_FLUFL\n")
    result = console.runsource("""print("black" <> 'blue')\n""")
print(repr(result))
print(repr(f.getvalue()))
