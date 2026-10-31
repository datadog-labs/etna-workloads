from unittest.mock import Mock

class Foo:
    def assert_bar(self): pass
    def assertSome(self): pass

m = Mock(spec=Foo)
try:
    m.assert_bar()
    m.assertSome()
    m.assert_bar.assert_called_once()
    print("ok")
except AttributeError as e:
    print("AttributeError:", e)
