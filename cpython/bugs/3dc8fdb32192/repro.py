fd = frozendict(a=1)
try:
    fd.__init__(b=2)
except Exception as e:
    print(type(e).__name__, e)
print(repr(fd))
