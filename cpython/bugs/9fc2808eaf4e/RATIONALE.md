# Rationale

Fix hunk: `_interp_exec` rejected a non-dict `shared` with TypeError "expected 'shared' to be a dict".
In v3.15.2 that check lives in the Argument Clinic spec: `shared: object(subclass_of='&PyDict_Type', ...)` for
`_interpreters.exec`, `run_string` and `run_func` in Modules/_interpretersmodule.c. I removed `subclass_of='&PyDict_Type'`
from all three and regenerated Modules/clinic/_interpretersmodule.c.h (`clinic.py`). A non-dict `shared` again reaches
the cross-interpreter code unchecked, which treats it as a dict.

Oracle: CommonTests.test_signatures and test_invalid_shared_none fail; the run then crashes (65 of 66 cases reported
failing as an incomplete run).
