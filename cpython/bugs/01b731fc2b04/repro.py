import difflib
try:
    print(repr(list(difflib._mdiff(["2"], ["3"], 1))))
except BaseException as e:
    print(type(e).__name__, e)
