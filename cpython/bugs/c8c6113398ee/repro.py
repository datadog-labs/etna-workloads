class MyEG(ExceptionGroup):
    pass

class MyBEG(BaseExceptionGroup, ValueError):
    pass

for cls in (MyEG, MyBEG):
    try:
        r = cls("eg", [ValueError(12), KeyboardInterrupt(42)])
        print("no error:", type(r).__name__)
    except TypeError as e:
        print("TypeError:", e)
