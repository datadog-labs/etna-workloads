from unittest.mock import Mock, PropertyMock
m = Mock()
p = PropertyMock()
type(m).foo = p
m.attach_mock(p, 'foo')
print(repr(m.mock_calls))
