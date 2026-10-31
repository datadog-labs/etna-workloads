# Rationale

The fix's logic still lives in `Lib/asyncio/taskgroups.py` and `Lib/asyncio/timeouts.py`. I reversed its hunks there directly.

## taskgroups.py `TaskGroup.__aenter__`
This reverses the fix hunk that moved `self._entered = True` to after the parent-task check. `_entered` is set again before the loop and parent-task lookup. If there is no current task, the `RuntimeError` is raised but the group stays marked as entered. I did not restore the old "has been already entered" message wording. Later code in 3.15 (`_cancel_on_enter`) is unchanged.

## timeouts.py `Timeout.__aenter__`
This reverses the fix hunk that added the "has already been entered" check and validated the task before changing state. The old code is back. It sets `_state = ENTERED`, calls `current_task()`, calls `.cancelling()` on the result, and only then checks for `None`. The old code raised `AttributeError` when there was no task, and the timeout was left in the ENTERED state. Entering a second time raises nothing.

I did not touch the `reschedule` hunk. It only replaced an assert with a RuntimeError, and the present code already behaves like the fixed version.

## Oracle cases that fail
- test_taskgroups `test_taskgroup_without_parent_task`, in both `TestTaskGroup` and `TestEagerTaskTaskGroup`. The group stays in the entered state after `__aenter__` fails, so the later `create_task` raises a different error instead of "has not been entered".
- test_timeouts `test_timeout_already_entered`, `test_timeout_double_enter` and `test_timeout_without_task`. Re-entering does not raise, and entering with no task fails with `AttributeError` and leaves the timeout in the wrong state.
