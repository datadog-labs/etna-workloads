Calls `asyncio.sleep(nan)` (under a 0.1s wait_for so the buggy build can't hang).
Clean: raises `ValueError: Invalid delay: NaN (not a number)`.
Buggy: the NaN check is missing, sleep never wakes up, so wait_for times out (`TimeoutError`).
