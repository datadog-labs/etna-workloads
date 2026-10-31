from _testcapi import PyUnicodeWriter
w = PyUnicodeWriter(0)
w.write_substring("abc", 1, 1)
print(repr(w.finish()))
