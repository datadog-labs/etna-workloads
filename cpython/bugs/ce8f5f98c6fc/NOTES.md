`repro.py` marshals `((frozenset([int]),), memoryview(b''))`. The frozenset holds an unmarshallable object, so it sets an error. Without the early return in `w_object`, marshal goes on to write the memoryview, which calls the getbuffer slot with an exception set.

- clean: prints `ValueError('unmarshallable object')`, exit 0.
- buggy: debug assertion `_Py_CheckSlotResult: Slot getbuffer of type memoryview succeeded with an exception set`, abort (exit -6).
