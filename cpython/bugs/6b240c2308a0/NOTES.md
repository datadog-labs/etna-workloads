`repro.py` prints `type.__type_params__`, then calls `functools.update_wrapper(wrapper, type)`
and prints the wrapper's `__type_params__`.
Clean: `()` both times. Buggy: `type.__type_params__` is a getset descriptor, and
`update_wrapper` raises `TypeError: __type_params__ must be set to a tuple`.
