import io, pickle, _pickle

def pid(obj):
    print("pid called", obj)
    return obj

p = _pickle.Pickler(io.BytesIO())
old = p.persistent_id
try:
    p.persistent_id = pid
    print(p.persistent_id is pid)
    p.dump('abc')
    del p.persistent_id
    print(p.persistent_id == old)
except Exception as e:
    print(type(e).__name__, e)

u = _pickle.Unpickler(io.BytesIO(pickle.dumps('abc')))
old = u.persistent_load
try:
    u.persistent_load = lambda x: x
    print(u.load())
    del u.persistent_load
    print(u.persistent_load == old)
except Exception as e:
    print(type(e).__name__, e)
