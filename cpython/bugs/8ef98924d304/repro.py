import re, weakref, gc

class C: pass

def clean(s):
    return re.sub(r'0x[0-9a-fA-F]+', '0xADDR', s)

obj = C()
r = weakref.ref(obj)
p = weakref.proxy(obj)
print(clean(repr(r)))
print(clean(repr(p)))
obj = None
gc.collect()
print(clean(repr(r)))
print(clean(repr(p)))
