import _testcapi
ids = []
try:
    while True:
        ids.append(_testcapi.add_type_watcher(0))
except RuntimeError:
    pass
print(ids)
class C: pass
_testcapi.watch_type(ids[-1], C)
C.foo = "bar"
print(_testcapi.get_type_modified_events() == [C])
