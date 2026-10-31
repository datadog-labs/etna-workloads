import sys
class NotAModule: ...
nm = NotAModule()
nm.symbol = 123
nm.__spec__ = []
sys.modules["not_a_module"] = nm
try:
    from not_a_module import missing_symbol
except ImportError as e:
    print(repr(str(e)))
