import asyncio, inspect
from unittest.mock import create_autospec

async def f(a, b): pass

spec = create_autospec(f)
print(inspect.iscoroutinefunction(spec))
aw = spec()
print(spec.mock_calls)
try:
    asyncio.run(aw)
except TypeError as e:
    print("TypeError")
print(spec.await_count, spec.mock_calls)
