import enum
try:
    class BadSuper(enum.IntEnum):
        def __new__(cls, value):
            return super().__new__(cls, value)
        failed = 1
except Exception as e:
    print(type(e).__name__, e)
else:
    print("no error")
