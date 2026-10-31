import traceback

class Falsey(Exception):
    def __bool__(self):
        return False

try:
    try:
        raise ValueError("cause")
    except ValueError as c:
        raise Falsey("outer") from c
except Falsey as e:
    print(traceback.TracebackException.from_exception(e).__cause__ is None)
