# Rationale

In v3.15.2, `threads.main` / `_PyInterpreterState_IsRunningMain()` already exist, so the fix's
pystate/threading hunks can't be reversed. The surviving fix hunks are the `_xxsubinterpreters`
ones that replaced the frame-based `_is_running()` with `_PyInterpreterState_IsRunningMain()` in
`interp_is_running` and `interp_destroy`. Those callers now go through `is_running_main()` in
`Modules/_interpretersmodule.c`.

Changed: `is_running_main()` is back to the pre-fix `_is_running()` logic. It looks at the
interpreter's head thread state and errors with "interpreter has more than one thread" if there
are several. Otherwise it reports "running" when the thread has a live frame
(`current_frame != base_frame`; the old `frame == NULL` check, adapted to `base_frame`). It now
returns -1 on error, and `_interpreters_destroy` and `_interpreters_is_running_impl` check for it,
as the pre-fix `interp_is_running` and `_ensure_not_running` did. This reverses the
`_is_running` removal and the `_PyInterpreterState_IsRunningMain` replacements in
`interp_destroy` and `interp_is_running`.

Oracle failure: `test_threading.SubinterpThreadingTests.test_threads_join_with_no_main` fails.
`interp.close()` raises `InterpreterError: interpreter running`. Background threads of a
subinterpreter are mistaken for the interpreter still running, so it can't be destroyed.
Other oracle cases passed in `check.sh`.
