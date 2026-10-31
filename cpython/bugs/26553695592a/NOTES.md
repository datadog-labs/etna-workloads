repro.py starts an asyncio server on localhost, schedules `wait_closed()` while the server is still open (no clients), and prints whether it finished early.

Clean: `wait_closed` blocks until `close()`; prints `False` then `finished`.
Buggy: `wait_closed` returns immediately, so it prints `True`. The buggy check also reads a nonexistent `_active_count`, so `await t` raises AttributeError and the exit status is 1.
