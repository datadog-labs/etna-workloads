Subclasses ctypes._Pointer without `_type_`, uses it in argtypes and calls the function.
Clean: raises ctypes.ArgumentError (TypeError "POINTER _type_ type is not set").
Buggy: `assert(typeinfo->proto)` fires in from_param, aborting the debug interpreter.
