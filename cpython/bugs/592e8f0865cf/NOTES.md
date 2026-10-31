Reproducer: shares one object's managed `__dict__` with another object, builds a cycle through it, drops the original and runs gc.collect().
Clean: prints the intact `ref` dict and `'whatever'`. Buggy: the GC doesn't traverse the shared dict, so it is wrongly cleared (wrong output / KeyError / crash).
