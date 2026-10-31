import _testcapi

class MyObj: pass
o = MyObj()

wid = _testcapi.add_dict_watcher(0)
_testcapi.watch_dict(wid, o.__dict__)
o.foo = "bar"
o.foo = "baz"
del o.foo
print(_testcapi.get_dict_watcher_events())
_testcapi.clear_dict_watcher(wid)
