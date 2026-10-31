import sys
sys.modules['_decimal'] = None  # force pure-Python decimal
sys.set_int_max_str_digits(0)
try:
    s = str(10**100000 + 12345)
    print(len(s), s[:5], s[-5:])
except RecursionError:
    print("RecursionError")
