try:
    print(repr(b'abc'.__buffer__(-2**31 - 1)))
except OverflowError as e:
    print("OverflowError", e)
