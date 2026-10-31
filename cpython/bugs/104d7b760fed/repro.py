code = """
l = [1, 2]
y = 0
items = [locals()["x"] for x in l]
items3 = [("x" in dir()) for x in l]
items4 = [eval("x") for x in l]
[exec("y = x") for x in l]
"""
ns = {}
try:
    exec(code, ns)
    print(ns["items"], ns["items3"], ns["items4"], ns["y"])
except Exception as e:
    print(type(e).__name__, e)

class C:
    try:
        exec(code)
        print(locals()["items"])
    except Exception as e:
        print(type(e).__name__, e)
