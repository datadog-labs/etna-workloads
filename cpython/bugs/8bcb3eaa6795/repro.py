import sys
def f(importer, imported, fromlist):
    print(repr(imported), repr(fromlist))
    return True
sys.set_lazy_imports_filter(f)
__lazy_import__("json", fromlist="dumps")
__lazy_import__("os", fromlist=("path",))
