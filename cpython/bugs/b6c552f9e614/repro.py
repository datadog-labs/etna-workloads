class TupleSubclass(tuple): pass

typ = type("typ", TupleSubclass((int, object)), {})
print(typ.__bases__, type(typ.__bases__).__name__)
