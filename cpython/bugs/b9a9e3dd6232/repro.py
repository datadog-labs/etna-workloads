import pydoc
func = lambda a, b, c: 1
func.__annotations__ = {"a": int, "b": int, "c": int, "return": int}
print(pydoc.plain(pydoc.render_doc(func)))
