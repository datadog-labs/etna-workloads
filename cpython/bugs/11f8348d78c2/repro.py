import inspect

class NoncomparableCallable:
    def __call__(self, a):
        pass
    def __eq__(self, other):
        1/0

print(inspect.signature(NoncomparableCallable()))
