Cancels a task that is runnable (its future already resolved), then uncancels it.
Clean: uncancel() resets _must_cancel, so the task finishes and prints 42.
Buggy: _must_cancel stays set, so the task is cancelled and prints "cancelled".
