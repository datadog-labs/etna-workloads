Reproducer: a threading.local holds an object whose __del__ calls PyGILState_Ensure/Release
(`_testcapi.gilstate_ensure_release`); it is set in a thread started by `_testcapi._test_thread_state`.
The destructor runs inside PyThreadState_Clear() during PyGILState_Release.

Clean: prints "done", exit 0.
Buggy: gilstate_counter is 0 during Clear, so the nested Release asserts
(`oldstate == PyGILState_UNLOCKED` in PyGILState_Release) and the process aborts (SIGABRT, -6).
