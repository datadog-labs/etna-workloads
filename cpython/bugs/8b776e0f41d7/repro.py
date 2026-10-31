import functools

class A:
    @functools.singledispatchmethod
    def t(self, *args, **kwargs):
        pass

for call in (lambda: A().t(), lambda: A().t(a=1)):
    try:
        call()
        print("no error")
    except Exception as e:
        print(type(e).__name__, e)
