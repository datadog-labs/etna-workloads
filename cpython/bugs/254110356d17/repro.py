called = False
class A:
    def __annotate__(format):
        global called
        called = True
        return {'a': int}

print(A.__annotations__)
del A.__annotations__
called = False
print(A.__annotations__)
print(called)
print(A.__annotate__)
