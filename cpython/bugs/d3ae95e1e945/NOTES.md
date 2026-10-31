Starts a child that closes its stdout but keeps running, then calls `communicate(timeout=0.1)` twice.
The first call times out and closes `proc.stdout` in the parent. On the second call:
- clean: raises `TimeoutExpired` again (prints `timeout2`).
- buggy: tries to register the closed stdout with the selector and raises `ValueError: Invalid file object` (prints `ValueError Invalid file object: <_io.BufferedReader name=3>`).
