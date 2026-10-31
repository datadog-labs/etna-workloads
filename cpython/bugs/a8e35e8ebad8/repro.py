import io, contextlib
from _pyrepl.console import InteractiveColoredConsole
c = InteractiveColoredConsole()
f = io.StringIO()
with contextlib.redirect_stdout(f):
    c.runsource("from __future__ import barry_as_FLUFL\n")
    r = c.runsource("""print("black" <> 'blue')\n""")
print(repr(r), repr(f.getvalue()))
