import traceback
try:
    traceback.print_exception(42)
except Exception as e:
    print(type(e).__name__, e)
