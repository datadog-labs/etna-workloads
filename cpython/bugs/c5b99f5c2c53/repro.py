import asyncio

called = False
pad = lambda: ...

class Loop:
    def get_debug(self):
        return False
    def call_soon(self, *args, **kwargs):
        global called
        if called:
            fut.remove_done_callback(int)
            fut.remove_done_callback(pad)
        else:
            called = True

fut = asyncio.Future(loop=Loop())
fut.add_done_callback(str)
fut.add_done_callback(int)
fut.add_done_callback(pad)
fut.set_result(1)
print("done")
