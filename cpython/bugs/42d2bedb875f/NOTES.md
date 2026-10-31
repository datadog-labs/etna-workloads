Creates a C Task with a loop whose call_exception_handler re-registers the task (`_c_register_task`) while it is being finalized (the loop lacks call_soon, so Task init fails with AttributeError and the task is finalized). Then `_c_all_tasks(loop)` is called after gc.
Clean: prints AttributeError, done, 0; exit 0.
Buggy: TaskObj_dealloc unregisters before finalizing, so the re-registered dead task stays in the list; abort with `add_tasks_llist: Assertion task->task_state == STATE_PENDING failed` (exit 134).
Note: ./check.sh failed in my sandbox (bwrap missing .claude/launch.json), so I ran both interpreters by hand.
