repro.py binds a bound method to another object via `a.meth.__get__(b, B)`, stores it on `b`, and checks that `b.meth()` returns `a`.

Clean: prints `True`. `method.__get__` returns the method unchanged (the fix adds `tp_descr_get` to `PyMethod_Type`).
Buggy: prints `False`. The descriptor is chained, so the method is rebound to `b`.

I couldn't run `./check.sh` because bwrap failed on a missing `.claude/launch.json` path. I ran both interpreters directly from an empty temp directory instead.
