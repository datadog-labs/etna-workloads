import _pydecimal
Decimal = _pydecimal.Decimal
class H:
    def __hash__(self):
        return 42
class D(Decimal, H):
    pass
value = D('NaN')
print(hash(value) == object.__hash__(value))
