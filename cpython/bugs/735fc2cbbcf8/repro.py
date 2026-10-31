from unittest.mock import Mock, create_autospec

class Order:
    @staticmethod
    def get_value():
        return "third"

m = Mock(spec=Order, wraps=Order)
print(repr(m.get_value.return_value))
print(repr(m.get_value()))

def f():
    return 'real'
a = create_autospec(f, wraps=f)
print(repr(a()))
