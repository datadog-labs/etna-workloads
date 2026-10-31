from _pyrepl.console import InteractiveColoredConsole
import io, contextlib
f = io.StringIO()
with contextlib.redirect_stderr(f):
    r = InteractiveColoredConsole().runsource("def f(x, x): ...")
print(r)
print(f.getvalue())
