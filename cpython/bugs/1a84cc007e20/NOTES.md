repro.py runs a child interpreter where an object's __del__ (run at shutdown) calls _thread.interrupt_main().
Clean: child exits 0 and stderr has "OSError: Signal 2 ignored due to race condition".
Buggy: compare_handler lacks the NULL check, so the child segfaults (returncode -11).
