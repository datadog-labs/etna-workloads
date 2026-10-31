import gc

class Shenanigans:
    pass

to_be_deleted = Shenanigans()
to_be_deleted.attr = "whatever"
holds_reference = Shenanigans()
holds_reference.__dict__ = to_be_deleted.__dict__
holds_reference.ref = {"circular": to_be_deleted, "data": 42}

del to_be_deleted
gc.collect()
print(sorted(holds_reference.ref))
print(repr(holds_reference.attr))
