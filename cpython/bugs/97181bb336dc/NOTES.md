Calls a `singledispatchmethod` through the class (`C.generic(C(), arg)`).
The clean interpreter dispatches on the second argument (`'generic'`, `'special1'`, `'special3'`).
The buggy one dispatches on the first argument (the instance), so every call returns `'generic'` or raises.
