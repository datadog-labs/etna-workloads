import asyncio
from asyncio import futures

loop = asyncio.new_event_loop()
fut = futures._CFuture(loop=loop)

fut.add_done_callback(str)
for _ in range(63):
    fut.add_done_callback(id)


class Evil:
    def __eq__(self, other):
        # Mutate fut_callbacks (by clearing it) while the C
        # implementation of remove_done_callback is iterating over it.
        fut.remove_done_callback(other)
        return False


result = fut.remove_done_callback(Evil())
print(result)

loop.close()
