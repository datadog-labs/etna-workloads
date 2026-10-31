import _imp

class Spec:
    name = ""

try:
    print(repr(_imp.create_builtin(Spec())))
except ValueError as e:
    print("ValueError:", e)
