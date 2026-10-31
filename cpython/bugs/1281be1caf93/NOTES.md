Calls `l.append(1)` in a loop with a `list` subclass instance, then checks the adaptive bytecode for CALL_LIST_APPEND.
Clean prints False (specializes to CALL_METHOD_DESCRIPTOR_O); buggy prints True (specializer no longer checks PyList_CheckExact).
