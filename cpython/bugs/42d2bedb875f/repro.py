import asyncio.tasks as tasks

class EvilLoop:
    def get_debug(self):
        return False

    def call_exception_handler(self, context):
        tasks._c_register_task(context["task"])

async def coro_fn():
    pass

coro = coro_fn()
loop = EvilLoop()
try:
    tasks._CTask(coro, loop=loop)
except AttributeError:
    print("AttributeError")
coro.close()
print("done")
import gc
gc.collect()
print(len(tasks._c_all_tasks(loop)))
