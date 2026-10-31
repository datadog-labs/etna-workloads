import io, pickle

def reducer():
    try:
        unpickler.load()
    except RuntimeError as e:
        print("RuntimeError:", e)
    return 42

f = io.BytesIO(b'(c__main__\nreducer\n(tRl.')
unpickler = pickle.Unpickler(f)
print(unpickler.load())
