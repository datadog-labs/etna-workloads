import contextlib, io
from _pyrepl.console import InteractiveColoredConsole

console = InteractiveColoredConsole()
f = io.StringIO()
with contextlib.redirect_stderr(f):
    console.runsource("raise Exception('foobar')\nprint('spam&eggs')\n")
print('Exception: foobar' in f.getvalue())
