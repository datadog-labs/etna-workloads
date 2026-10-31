import traceback

try:
    raise ExceptionGroup("test", [ValueError("boom")])
except Exception as e:
    exc = traceback.TracebackException.from_exception(e)

out = "".join(exc.format(colorize=True))
print("sub-exception colorized:", "\x1b[" in out.split("1 ----")[1])
