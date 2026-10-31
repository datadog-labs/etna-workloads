class MyObj: pass
class DelKey:
    def __del__(self):
        try:
            del d['b']
        except KeyError:
            pass

x = MyObj()
x.a = DelKey()
x.b = "value_b"
x.c = "value_c"

d = x.__dict__
d.clear()
print(repr(d), len(d))
