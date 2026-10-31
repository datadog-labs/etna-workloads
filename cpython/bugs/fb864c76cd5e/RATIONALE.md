# Rationale

Fix hunk reversed: `Lib/logging/config.py`, which replaced the strict type check on
`QueueHandler` queue specs with `_is_queue_like_object()`, a duck-typed check of the Queue API.

In v3.15.2 `_is_queue_like_object` still exists, but it ends in a protocol check
(`put_nowait` and `get` callable, from gh-124653). I removed that protocol check, so the
function accepts only `queue.Queue`/`SimpleQueue` and `multiprocessing.queues.Queue`
instances and returns `False` for everything else. This restores the pre-fix constraint that
a queue object must be a real queue type. Objects that only implement the Queue API are
rejected with `TypeError('Invalid queue specifier ...')`, which `dictConfig` wraps in
`ValueError`. The same applies to manager queue proxies.

Only a `return False` remains where the protocol check was. The hunk's call site is unchanged.

## Oracle
`./check.sh` reports 7 errors in `test_logging`, all
`ValueError: Unable to configure handler ...`. They come from the cases the fix added or
extended: `CustomQueueProtocol`, which implements the Queue API without subclassing
`queue.Queue`, and `CustomQueueFakeProtocol`. I read the 7 errors from the tail of the
`check.sh` output only. I did not map each one to a test name.
