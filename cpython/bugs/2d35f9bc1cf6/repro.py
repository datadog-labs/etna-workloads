from collections import defaultdict

class F:
    def __call__(self):
        return {}
    def __repr__(self):
        repr(dd)
        return f"F for {dd}"

dd = defaultdict(F())
try:
    print(repr(dd))
except RecursionError:
    print("RecursionError")
