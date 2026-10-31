Runs `asyncio.timeout(0)` around `asyncio.sleep(0)`. Clean: the timeout fires via
`call_soon` (deadline already passed), so TimeoutError is raised and expired() is True.
Buggy: uses `call_at`, which fires after the sleep(0) finishes, so no TimeoutError
and expired() is False.
