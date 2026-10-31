Forks, then in the child compares `threading.current_thread().native_id` with `threading.get_native_id()`.
Clean prints `True`; buggy prints `False` because the child's native_id isn't refreshed after fork.
