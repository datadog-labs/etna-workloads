import sqlite3

def dict_factory(cu, row):
    return dict(zip([c[0] for c in cu.description], row))

cx = sqlite3.connect(":memory:")
cx.row_factory = dict_factory
cx.execute("CREATE TABLE test(t);")
try:
    print(list(cx.iterdump()))
except Exception as e:
    print(type(e).__name__, e)
print(cx.row_factory is dict_factory)
cx.close()
