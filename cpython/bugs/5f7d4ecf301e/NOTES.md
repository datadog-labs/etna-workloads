Calls multiprocessing.managers.dispatch() with a fake connection whose recv() returns ('#ERROR', queue.Empty()), with gc disabled, and checks whether the caught exception is freed (weakref dead) once the except block ends.
Clean prints True (no reference cycle; `result` is deleted in a finally). Buggy prints False (the exception stays alive in a cycle until the gc runs).
