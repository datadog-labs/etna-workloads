from unittest.mock import Mock

class S:
    _instance = None
    @property
    def instance(self):
        print("property called")
        self._instance = object()
        return 'object'

obj = S()
Mock(spec=obj)
print(repr(obj._instance))
