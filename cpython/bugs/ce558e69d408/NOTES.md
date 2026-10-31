repro.py starts a thread from a `__del__` that runs during interpreter finalization
(translation of test_start_new_thread_at_finalization).
Clean: start_new_thread raises PythonFinalizationError ("can't create new thread at
interpreter shutdown"), printed as an unraisable exception; only "OK" is printed.
Buggy: the check is removed, so the thread is created during shutdown (output/exit differs).
