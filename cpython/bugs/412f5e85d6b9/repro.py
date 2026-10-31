import sys
E = sys.monitoring.events
T1, T2 = 3, 4
for t in (T1, T2):
    sys.monitoring.use_tool_id(t, "t%d" % t)
def f():
    pass
code = f.__code__
sys.monitoring.set_local_events(T1, code, E.INSTRUCTION | E.LINE)
sys.monitoring.set_local_events(T2, code, E.LINE)
print("ok")
sys.monitoring.set_events(T1, 0)
sys.monitoring.set_events(T2, 0)
