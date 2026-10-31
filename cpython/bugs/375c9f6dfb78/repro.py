import inspect
from warnings import deprecated

@deprecated("depr")
def sync():
    pass

@deprecated("depr")
async def coro():
    pass

print(inspect.iscoroutinefunction(sync))
print(inspect.iscoroutinefunction(coro))
