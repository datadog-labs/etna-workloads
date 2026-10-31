Sets `sys.last_exc` and calls `traceback.print_last(file=sys.stdout)`.
Clean: prints `ValueError: 42`. Buggy: print_last passes limit/file/chain positionally to print_exception, which misinterprets them (wrong output or TypeError).
