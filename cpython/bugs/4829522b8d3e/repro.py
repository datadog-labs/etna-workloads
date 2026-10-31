class PropertySub(property):
    """A subclass of property"""

class NoDoc:
    @property
    def __doc__(self):
        raise AttributeError

print(repr(property(NoDoc()).__doc__))
print(repr(PropertySub(NoDoc()).__doc__))
