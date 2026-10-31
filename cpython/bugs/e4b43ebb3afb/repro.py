from unittest.mock import Mock, seal

class AsyncClass:
    async def async_method(self): pass
    def normal_method(self): pass

m = Mock(AsyncClass)
seal(m)
try:
    print(type(m.async_method).__name__)
except AttributeError as e:
    print("AttributeError", e)
