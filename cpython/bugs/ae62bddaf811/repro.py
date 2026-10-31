import _testcapi

def f(a):
    return a

def g(*, a):
    return a

try:
    print(repr(_testcapi.eval_code_ex(f.__code__, {}, {}, (), {}, (1,))))
except Exception as e:
    print(type(e).__name__, e)
try:
    print(repr(_testcapi.eval_code_ex(g.__code__, {}, {}, (), {}, (), dict(a=1))))
except Exception as e:
    print(type(e).__name__, e)
