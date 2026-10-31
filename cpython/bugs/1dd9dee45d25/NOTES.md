repro.py: creates a subinterpreter that starts a background thread plus a threading atexit hook (translation of test_threads_join_with_no_main), closes it, and reads the 3 pipe bytes (I, F, D).
Clean: prints b'I', b'F', b'D' and exits 0. Buggy: interp.close() hangs/times out (is_running_main is wrong when background threads exist).
