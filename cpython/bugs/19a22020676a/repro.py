import sys, importlib.util, importlib.abc

SRC = """\
import sys
from types import ModuleType

CONSTANT = 3.14

class ImmutableModule(ModuleType):
    def __setattr__(self, name, value):
        raise AttributeError('Read-only attribute!')

sys.modules[__name__].__class__ = ImmutableModule
"""

with open("lazymod.py", "w") as f:
    f.write(SRC)

spec = importlib.util.spec_from_file_location("lazymod", "lazymod.py")
spec.loader = importlib.util.LazyLoader(spec.loader)
module = importlib.util.module_from_spec(spec)
sys.modules["lazymod"] = module
spec.loader.exec_module(module)
print(type(module).__name__)
print(module.CONSTANT)
print(type(module).__name__)
try:
    module.CONSTANT = 2.71
except AttributeError as e:
    print("AttributeError", e)
else:
    print("assigned", module.CONSTANT)
