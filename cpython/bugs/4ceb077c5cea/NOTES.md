repro.py calls sys.activate_stack_trampoline("perf_jit") and reports whether the trampoline is active, then deactivates it.
Clean: prints True / False. Buggy: ValueError "invalid backend: perf_jit", because the injected patch nests the perf_jit branch inside the "perf" branch.
