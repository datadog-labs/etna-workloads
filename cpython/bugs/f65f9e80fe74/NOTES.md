reprlib.recursive_repr wrapper must copy __type_params__ from the wrapped generic method. Clean prints 1 and [('T', <class 'str'>)]; buggy prints 0 and [].
