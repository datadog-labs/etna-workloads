import functools

class Item:
    @functools.cached_property
    def cost(self):
        return 1

print(repr(Item.__dict__['cost'].__module__))
