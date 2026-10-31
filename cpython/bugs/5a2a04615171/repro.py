import sys
E = sys.monitoring.events
T = 3
sys.monitoring.use_tool_id(T, "t")

class Foo:
    def __init__(self, set_event):
        if set_event:
            sys.monitoring.set_events(T, E.PY_RESUME)

try:
    for i in range(100):
        Foo(i == 99)
finally:
    sys.monitoring.set_events(T, 0)
    sys.monitoring.free_tool_id(T)
print("done")
