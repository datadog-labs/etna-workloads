import sched

events = []
s = sched.scheduler()
s.enterabs(1, 1, events.append, ("a",))
b = s.enterabs(1, 1, events.append, ("b",))
s.enterabs(1, 1, events.append, ("c",))
s.cancel(b)
s.run()
print(events)
