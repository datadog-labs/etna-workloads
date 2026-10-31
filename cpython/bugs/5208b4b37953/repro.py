import math

class F:
    def __float__(self):
        self.converted = True
        1/0

for func in math.atan2, math.copysign, math.remainder:
    y = F()
    try:
        func("not a number", y)
    except BaseException as e:
        print(func.__name__, type(e).__name__)
    print(getattr(y, "converted", False))
