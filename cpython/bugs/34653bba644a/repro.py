from enum import Enum

class InvalidRgbColorError(ValueError):
    def __init__(self, r, g, b):
        self.r = r
        super().__init__(f'({r}, {g}, {b}) is not a valid RGB color')

try:
    class RgbColor(Enum):
        RED = (255, 0, 0)
        INVALID = (256, 0, 0)

        def __init__(self, r, g, b):
            if not all(0 <= v <= 255 for v in (r, g, b)):
                raise InvalidRgbColorError(r, g, b)
except Exception as e:
    print(type(e).__name__, e)
