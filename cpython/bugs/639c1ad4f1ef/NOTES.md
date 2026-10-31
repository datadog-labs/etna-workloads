repro.py passes non-str keyword keys to ast.Name(...) and Name.__replace__.
Clean: TypeError "unexpected keyword argument <object ...>" is raised normally.
Buggy: the error format uses '%U' on a non-str key, so a debug build aborts with
a unicode assertion failure (exit -6) on the first call.
