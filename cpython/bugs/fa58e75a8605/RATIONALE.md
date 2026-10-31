# gh-116720 reintroduced (taskgroup corner cases / uncancel)

Changes in tree/:
1. `Lib/asyncio/tasks.py` `Task.uncancel`: removed the `if self._num_cancels_requested == 0: self._must_cancel = False` reset (reverses the tasks.py hunk).
2. `Modules/_asynciomodule.c` `_asyncio_Task_uncancel_impl`: removed the equivalent `task_must_cancel = 0` reset (reverses the C hunk; same defect in the C Task).
3. `Lib/asyncio/taskgroups.py` `_aexit`: removed the "if self._parent_task.cancelling(): uncancel(); cancel()" block before raising the ExceptionGroup (reverses the third taskgroups hunk). The relocation of the uncancel block was not reverted, since v3.15.2 has since added gh-155433 logic there.

Oracle failures: `test_uncancel_resets_must_cancel` (all Task variants, Py and C), plus test_cancel / test_cancel_gather_2 / FutureGatherTests.test_success in test_tasks.
After uncancel() to zero, the stale `_must_cancel` flag still raises CancelledError, as before the fix.
