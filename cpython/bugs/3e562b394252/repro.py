import annotationlib

def define(name, future, annos, base, ns=None):
    lines = ["from __future__ import annotations"] if future else []
    lines.append(f"class {name}({base}):")
    lines.append(f"    {name}_attr: int" if annos else "    pass")
    g = dict(ns or {})
    exec("\n".join(lines), g)
    return g[name]

Meta = define("Meta", True, True, "type")
Base = define("Base", False, False, "metaclass=Meta", {"Meta": Meta})
print(repr(annotationlib.get_annotations(Base)))
