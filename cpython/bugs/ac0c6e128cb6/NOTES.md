repro.py calls `enumerate(iterable=...)`, `enumerate(iterable=..., start=0)` and `enumerate(start=0, iterable=...)`.

Clean: each prints `[(0, 5)]`.
Buggy: each raises `TypeError: enumerate() missing required argument 'iterable'`, because the vectorcall path checks `nargs == 0` before considering keyword arguments.

I ran both interpreters directly. `./check.sh` failed with a bwrap sandbox error in this session, so I didn't use it.
