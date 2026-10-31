import io, pickle, _pickle

class P(_pickle.Pickler):
    def persistent_id(self, obj):
        return super().persistent_id(obj)

class U(_pickle.Unpickler):
    def persistent_load(self, pid):
        return super().persistent_load(pid)

f = io.BytesIO()
try:
    P(f, 2).dump('abc')
    print('pickler', pickle.loads(f.getvalue()))
except BaseException as e:
    print('pickler', type(e).__name__)

class P2(_pickle.Pickler):
    def persistent_id(self, obj):
        return obj
f = io.BytesIO()
P2(f, 2).dump('abc')
try:
    print('unpickler', U(io.BytesIO(f.getvalue())).load())
except BaseException as e:
    print('unpickler', type(e).__name__)

# instance attribute
f = io.BytesIO()
p = _pickle.Pickler(f, 2)
p.persistent_id = lambda obj: None
p.dump('abc')
print(pickle.loads(f.getvalue()))
