import sys
E_ = sys.monitoring.events
def foo():
    t = 0
    for i in [1, 2, 3, 4]:
        t += i
    return t

sys.monitoring.use_tool_id(0, "test")
sys.monitoring.set_local_events(0, foo.__code__, E_.BRANCH_LEFT | E_.BRANCH_RIGHT)
print(foo())
sys.monitoring.set_local_events(0, foo.__code__, 0)
sys.monitoring.free_tool_id(0)
