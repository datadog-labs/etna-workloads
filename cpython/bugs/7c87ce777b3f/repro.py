import trace

def f(a, b):
    c = a + b
    return c

f = type(f)(f.__code__.replace(co_filename="<unknown>"), globals())
trace.Trace(count=0, trace=1).runfunc(f, 2, 3)
