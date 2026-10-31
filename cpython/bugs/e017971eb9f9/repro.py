class BadStr(str):
    def __eq__(self, _):
        raise RuntimeError("Poison!")
    __hash__ = str.__hash__

c1 = compile("pass", "test", "exec")
c2 = c1.replace(co_name=BadStr("poison"))
c3 = compile("pass", "poison", "exec")
try:
    print(c2 == c3)
except RuntimeError as e:
    print("RuntimeError", e)
