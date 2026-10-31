import _interpreters

interp = _interpreters.create()
script = """
import contextvars
print(getattr(contextvars.Token, "MISSING", "doesn't exist"))
"""
exc = _interpreters.exec(interp, script)
print(repr(exc))
