Reproducer for test_entry_frames_are_invisible_during_teardown: a weakref callback (exec) runs while f's frame is cleared; f was called via operator.call, so a shim frame sits above it, and exec looks up the current globals/locals.

- Clean: exec raises TypeError, reported through the unraisable hook. Output is "unraisable: TypeError" then "None", exit 0.
- Buggy: PyEval_GetGlobals and related functions use tstate->current_frame directly and can see the incomplete shim frame. The interpreter segfaults (exit -11).
