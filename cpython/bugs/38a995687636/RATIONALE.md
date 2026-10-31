# Rationale

Hunk reversed: `Lib/asyncio/base_events.py` `BaseEventLoop.create_task` (fix hunk @@ -458,25 +458,18).
`create_task` again takes only `name`/`context`, and with a custom task factory calls it as
`factory(loop, coro)` (or with `context=` only), then applies `task.set_name(name)` afterwards,
instead of forwarding `**kwargs`. The gh-128552 `try/finally: del task` refcycle fix is kept.
Eager task factories therefore start the task before the name is set.

The `events.py` signature, docstring and docs hunks were not reverted (no behavioural effect).

Oracle failure: `test_asyncio.test_taskgroups ... test_name` fails with
`'Task-87' != 'example name'`, since the coroutine runs eagerly before `set_name`.
