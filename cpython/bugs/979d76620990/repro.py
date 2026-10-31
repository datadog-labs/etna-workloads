import pydoc, types

class A:
    def method(self):
        pass
    method.__module__ = None

m = types.ModuleType("mod")
m.A = A
A.__module__ = "mod"
pydoc.render_doc(m)
print("ok")
