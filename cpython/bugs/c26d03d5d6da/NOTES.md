Reproducer: sets a trace function that raises once (via sys.settrace plus f_trace) and prints the
function names in the resulting exception traceback.
Clean: ['f', 'error_once']. Buggy: ['f', 'f', 'error_once'], because call_trampoline
calls PyTraceBack_Here again, so the frame is duplicated in the traceback.
