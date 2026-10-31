from reprlib import recursive_repr

class My:
    @recursive_repr()
    def __repr__[T: str](self, default: T = '') -> str:
        return default

tp = My().__repr__.__type_params__
print(len(tp))
print([(p.__name__, p.__bound__) for p in tp])
