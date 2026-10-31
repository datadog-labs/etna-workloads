class EvilTypeVar:
    __typing_is_unpacked_typevartuple__ = True
    def __typing_prepare_subst__(*_):
        return None
    def __typing_subst__(*_):
        return 42  # not a tuple

evil = EvilTypeVar()
type type_alias[*_] = 0
try:
    print(repr(type_alias[evil][0]))
except TypeError as e:
    print("TypeError:", e)
