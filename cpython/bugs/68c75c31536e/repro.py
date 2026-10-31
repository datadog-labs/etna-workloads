class MyType(type):
    pass

def test(name):
    mytype = MyType(name, (MyType,), {})
    super(MyType, type(mytype)).__setattr__(mytype, "bar", 1)
    return mytype.bar

for _ in range(100):
    r = test("foo1")
print(repr(r))
