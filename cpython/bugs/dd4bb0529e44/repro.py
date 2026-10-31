import sys

events = []
def prof(frame, event, arg):
    if frame.f_code.co_name == 'f':
        events.append((event, arg))

def f():
    for i in range(2):
        yield i

def g():
    next(f())

sys.setprofile(prof)
g()
sys.setprofile(None)
print(events)
