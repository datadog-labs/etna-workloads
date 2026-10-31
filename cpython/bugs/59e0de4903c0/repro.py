from unittest import mock

class Foo:
    @classmethod
    def cm(cls, a, b): pass
    @staticmethod
    def sm(a, b): pass

for name in ('cm', 'sm'):
    with mock.patch.object(Foo, name, autospec=True) as m:
        getattr(Foo, name)(1, 2)
        m.assert_called_once_with(1, 2)
        try:
            getattr(Foo, name)(1)
        except TypeError as e:
            print(name, 'TypeError', e)
        else:
            print(name, 'no error')
