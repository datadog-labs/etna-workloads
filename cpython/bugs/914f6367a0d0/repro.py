import asyncio
calls = []
policy = asyncio.events._get_event_loop_policy()
orig = policy.set_event_loop
policy.set_event_loop = lambda loop: (calls.append(1), orig(loop))
async def coro():
    pass
runner = asyncio.Runner()
runner.run(coro())
runner.run(coro())
print(len(calls))  # expected 1
runner.close()
