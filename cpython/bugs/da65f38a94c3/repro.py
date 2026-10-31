import _testcapi
try:
    t = _testcapi.create_managed_weakref_nogc_type()
    print("created", t.__name__)
except SystemError as e:
    print("SystemError:", e)
