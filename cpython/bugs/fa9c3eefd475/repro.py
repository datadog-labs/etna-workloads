from re import Scanner
try:
    Scanner([("(a)b", None)])
    print("no error")
except ValueError as e:
    print("ValueError:", e)
