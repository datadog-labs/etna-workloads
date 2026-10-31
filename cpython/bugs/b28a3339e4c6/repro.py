from unittest.mock import create_autospec, DEFAULT

class Something:
    def meth(self, a, b, c): pass

m = create_autospec(spec=Something, **{
    'return_value.meth.side_effect': [ValueError, DEFAULT],
    'return_value.meth.return_value': 'mocked value'})
try:
    m().meth(a=None, b=None, c=None)
except ValueError:
    print('ValueError')
print(repr(m().meth(a=None, b=None, c=None)))
