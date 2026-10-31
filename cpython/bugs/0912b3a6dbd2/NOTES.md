Reproducer: runs a script that sets `set_forkserver_preload(['__main__'])` and starts two forkserver
Processes (translation of Lib/test/mp_preload_main.py).
Clean: prints `__main__`, `__mp_main__` (preloaded once in forkserver), `f`, `f`.
Buggy: forkserver reads the wrong key (`main_path` instead of `init_main_from_path`), so `__main__` is
not preloaded and `__mp_main__` is printed by each child instead (or at a different count/order).
