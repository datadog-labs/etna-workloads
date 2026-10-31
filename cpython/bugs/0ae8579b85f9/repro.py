src = """
class C:
    [super for _ in [1]]
    [__class__ for _ in [1]]
"""
try:
    exec(src, {})
    print("ok")
except BaseException as e:
    print(type(e).__name__, e)
