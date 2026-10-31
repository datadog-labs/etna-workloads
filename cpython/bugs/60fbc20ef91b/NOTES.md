repro.py ports test_gh140947 (non-SSL): a create_server protocol creates a task from data_received,
which sets context vars and calls transport.resume_reading(). It prints the context vars visible in each callback.
Clean: connection_lost sees no cvars (`[]`). Buggy: the task's context leaks into the transport's
reader callback, so connection_lost sees `[('cvar1', True), ('cvar2', True)]`.
