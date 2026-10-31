import sys
ev = []
def prof(frame, event, arg):
    ev.append((event, frame.f_code.co_name, arg))
def f():
    for i in range(2):
        yield i
def g():
    next(f())
sys.setprofile(prof)
g()
sys.setprofile(None)
for e in ev:
    print(e)
