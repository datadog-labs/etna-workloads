import sys
print(repr(bytes(range(97, 102)).hex(':', -sys.maxsize - 1)))
