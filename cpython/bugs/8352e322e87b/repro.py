import weakref
for name in ('ReferenceType', 'ProxyType', 'CallableProxyType'):
    obj = getattr(weakref, name)
    print(name, obj.__module__, obj.__name__, obj.__qualname__)
