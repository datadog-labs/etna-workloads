Creates an InterpreterPoolExecutor with no thread_name_prefix and prints `_thread_name_prefix`.
Clean: `InterpreterPoolExecutor-0`. Buggy: `ThreadPoolExecutor-0`, because the subclass no longer sets its own default prefix.
