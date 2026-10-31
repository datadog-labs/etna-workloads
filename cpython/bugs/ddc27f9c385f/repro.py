class Evil(str):
    def __str__(self):
        exc.object = None
        return self

exc = UnicodeEncodeError("utf-8", "x", 0, 1, Evil("reason"))
try:
    print(str(exc))
except TypeError as e:
    print("TypeError", e)
