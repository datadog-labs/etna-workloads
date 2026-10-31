import traceback
try:
    print(repr(traceback.format_exception(None)))
except BaseException as e:
    print(type(e).__name__, e)
