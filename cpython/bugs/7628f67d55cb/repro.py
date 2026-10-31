from unittest.mock import MagicMock
mm = MagicMock()
print(type(mm.__str__()).__name__, type(mm.__hash__()).__name__)
mm.reset_mock(return_value=True)
print(type(mm.__str__()).__name__, type(mm.__hash__()).__name__)
