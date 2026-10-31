from typing import get_type_hints
class BadBase:
    foo: tuple
class BadType(BadBase):
    bar: list
BadType.__module__ = BadBase.__module__ = 'bad'
print(get_type_hints(BadType))
