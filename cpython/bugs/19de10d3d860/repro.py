import array
import _testcapi
print([_testcapi.buffer_pointer_as_int(array.array(f)) % 8 for f in "bhilqfd"])
