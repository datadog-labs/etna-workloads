Calls `_imp.create_builtin()` with a spec whose name is the empty string.
Clean: raises `ValueError: name must not be empty`.
Buggy: the empty-name check is removed, so it goes on to create_builtin() (crash/assert or wrong result instead of ValueError).
