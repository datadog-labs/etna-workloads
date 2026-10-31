# Rationale

Fix hunk (Lib/logging/config.py, configure_handler): the fix widened the `queue`
type check so that a multiprocessing Manager proxy queue (`MM().Queue()`) is
accepted, in addition to `queue.Queue` and `multiprocessing.queues.Queue`.
Before it, only those two concrete types were accepted.

In v3.15.2 that check lives in `_is_queue_like_object` (config.py), which accepts
`queue.Queue`/`SimpleQueue`, `MPQueue`, and then falls back to a duck-typing check
(`put_nowait` and `get`) - the code that covers manager proxies today. I removed
that fallback (`return False` instead), restoring the pre-fix behaviour of accepting
only concrete queue types, so a manager proxy queue is rejected with
`TypeError: Invalid queue specifier` (wrapped in `ValueError: Unable to configure handler 'ah'`).

Oracle: `test_multiprocessing_queues` fails for the `MM().Queue()` proxy
(q2). Other ConfigDictTest queue tests that use duck-typed queue objects also fail
(7 errors in test_logging total), since the duck-typing fallback is gone.
