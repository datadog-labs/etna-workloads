class slotted_prop(property):
    __slots__ = ("foo",)

for args, kw in [((), {}), ((), {"doc": "what's up"})]:
    try:
        p = slotted_prop(*args, **kw)
        print("ok", repr(getattr(p, "__doc__", None)))
    except Exception as e:
        print(type(e).__name__, e)
