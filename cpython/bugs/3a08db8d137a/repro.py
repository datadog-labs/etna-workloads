import _testcapi
try:
    _testcapi.mapping_getoptionalitemstring({}, b'\xff')
except UnicodeDecodeError as e:
    print("UnicodeDecodeError")
