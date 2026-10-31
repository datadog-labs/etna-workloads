import sys
mon = sys.monitoring
T = 0
mon.use_tool_id(T, "repro")
mon.set_events(T, mon.events.LINE)
mon.register_callback(T, mon.events.LINE, lambda code, line: None)

def f():
    def a():
        yield
    def b():
        yield from a()
    next(b())

f()
mon.set_events(T, 0)
print("done")
