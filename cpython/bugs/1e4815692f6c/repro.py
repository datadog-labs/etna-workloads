from unittest.mock import create_autospec
class X: ...
mock = create_autospec(X, spec_set=True, name="Y")
print(repr(mock._mock_name))
