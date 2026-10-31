import sys
E = sys.monitoring.events
def f(a, b):
    return a + b
args = (1, 2)
data = []
sys.monitoring.use_tool_id(0, "test")
sys.monitoring.register_callback(0, E.CALL, lambda code, offset, callable, arg0: data.append((callable is f, arg0)))
sys.monitoring.set_events(0, E.CALL)
f(*args)
sys.monitoring.set_events(0, 0)
sys.monitoring.free_tool_id(0)
print(data)
