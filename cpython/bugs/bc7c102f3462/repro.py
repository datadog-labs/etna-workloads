import sys, tomllib
n = sys.getrecursionlimit() + 2
try:
    tomllib.loads("a." * n + "a = 1")
    print("parsed")
except RecursionError as e:
    print("RecursionError:", e)
