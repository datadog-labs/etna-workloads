from _asyncio import _swap_current_task, _set_running_loop

class DummyTask:
    pass

class DummyLoop:
    pass

l = DummyLoop()
_set_running_loop(l)
_swap_current_task(l, DummyTask())
t = _swap_current_task(l, None)
print(type(t).__name__)
