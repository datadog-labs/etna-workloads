import itertools

grouper_iter = None

class Key:
    __hash__ = None

    def __init__(self, do_advance):
        self.do_advance = do_advance

    def __eq__(self, other):
        global grouper_iter
        if self.do_advance:
            self.do_advance = False
            if grouper_iter is not None:
                try:
                    next(grouper_iter)
                except StopIteration:
                    pass
            return NotImplemented
        return True

def keyfunc(element):
    if element == 0:
        return Key(do_advance=True)
    return Key(do_advance=False)

g = itertools.groupby(range(4), keyfunc)
key, grouper_iter = next(g)
items = list(grouper_iter)
print(len(items))
