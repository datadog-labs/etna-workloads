def f():
    T = str
    class C:
        T = int
        class D[U](T):
            x = T
    return C

C = f()
print(C.D.__bases__)
print(C.D.x)
