import sys
m = sys.monitoring
m.use_tool_id(0, "t")
def on_throw(code, offset, exc):
    print("throw", code.co_name, repr(exc))
m.register_callback(0, m.events.PY_THROW, on_throw)
m.set_events(0, m.events.PY_THROW)

def gen():
    yield 1
    yield 2

try:
    g = gen()
    next(g)
    g.throw(IndexError)
except IndexError:
    print("caught")
m.set_events(0, 0)
