import sys
M = sys.monitoring
events = []
M.use_tool_id(0, "t")
M.register_callback(0, M.events.PY_UNWIND, lambda code, off, exc: events.append(("unwind", type(exc).__name__, code.co_name)))

class B:
    def __init__(self):
        raise ValueError()

def f():
    try:
        return B()
    except ValueError:
        pass

for _ in range(100):
    f()
events.clear()
M.set_events(0, M.events.PY_UNWIND)
f()
M.set_events(0, 0)
M.free_tool_id(0)
print(events)
