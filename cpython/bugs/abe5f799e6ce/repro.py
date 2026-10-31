from typing import TypeAliasType
TA = TypeAliasType("TA", list[int], type_params=())
print(repr(TA.__type_params__))
try:
    print(repr(TA[int]))
except TypeError as e:
    print("TypeError:", e)
