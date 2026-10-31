repro.py defines a bytearray subclass whose `__release_buffer__` tries to create new views
(`memoryview(buf)`, `.cast`, `.toreadonly`, slicing, `__buffer__`) from the buffer it is handed.
Clean: every attempt raises ValueError ("cannot create new view on restricted memoryview").
Buggy: the memoryview is no longer marked restricted, so all five succeed ("no error").
