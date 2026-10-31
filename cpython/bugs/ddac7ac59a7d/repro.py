def test(default=None):
    return test()

try:
    test()
except RecursionError:
    print("RecursionError")
