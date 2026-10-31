repro.py: holds an RLock (C and pure-Python) twice in the main thread, then calls lock._recursion_count() from another thread. Clean returns 0 (not owner); buggy returns 2 (the owner's count).
