Reproducer: runtime-checkable Protocol with a non-callable member and a custom __subclasshook__; issubclass() should use the hook (True/False). The buggy build raises TypeError instead.
