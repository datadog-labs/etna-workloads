import traceback
import _interpreters

traceback.TracebackException.format = lambda self: ["x-no-nl"]
c = _interpreters.capture_exception(ValueError())
print(repr(c.formatted), repr(c.errdisplay))
