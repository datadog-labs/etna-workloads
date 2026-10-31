repro.py: registers an atexit callback that starts a thread which prints 24, sleeps 1s, prints 42.
Clean waits for the thread (prints 24 and 42); buggy exits after printing only 24 (thread not joined).
