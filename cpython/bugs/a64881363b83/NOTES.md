Reproducer: creates a subinterpreter (own GIL, daemon threads allowed), starts 3 daemon
threads that sleep, then destroys the interpreter (Py_EndInterpreter) while they run.

Clean: prints "done", exit 0 (remaining daemon threads are removed and shut down).
Buggy: Py_FatalError "Py_EndInterpreter: not the last thread", abort (exit -6).
