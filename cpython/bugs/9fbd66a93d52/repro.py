import _testcapi
obj = _testcapi.ManagedDictType()
obj.foo = 42
print(repr(obj.__dict__))
obj.__dict__ = {'bar': 3}
print(repr(obj.__dict__))
print(obj.bar)
