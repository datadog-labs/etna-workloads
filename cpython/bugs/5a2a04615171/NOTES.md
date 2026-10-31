repro.py is test_108390: it calls a class constructor (`Foo(...)`) 100 times so the specialized `__init__` shim frame is used, then enables PY_RESUME monitoring inside `__init__` on the last call.

Clean: prints `done`, exit 0.
Buggy: the early exit for shim code objects (CO_NO_MONITORING_EVENTS) is removed, so instrumentation data gets created for the shim code. The buggy interpreter crashes and prints nothing (see check.sh for the status).
