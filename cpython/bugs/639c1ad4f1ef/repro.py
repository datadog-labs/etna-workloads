import ast
import warnings
warnings.simplefilter("ignore")

try:
    ast.Name(**{object(): 'y'})
except TypeError as e:
    print(type(e).__name__, str(e).replace(" object at", "")[:60].split("<")[0])

class FakeStr:
    def __init__(self, value):
        self.value = value
    def __hash__(self):
        return hash(self.value)
    def __eq__(self, other):
        return isinstance(other, str) and self.value == other

try:
    ast.Name("x", **{FakeStr('id'): 'y'})
except TypeError as e:
    print(type(e).__name__, str(e).startswith("Name got multiple values"))

try:
    ast.Name(id="x").__replace__(**{object(): "y"})
except TypeError as e:
    print(type(e).__name__, str(e).split("<")[0])
