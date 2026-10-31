import sys
def f():
    return sys._getframe().f_locals
FLP = type(f())
for args in [(1,)]:
    try:
        FLP(*args)
    except Exception as e:
        print(type(e).__name__, e)
