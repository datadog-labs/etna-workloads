def g():
    yield

generator = g()
frame = generator.gi_frame
print(frame.f_back is None)
next(generator)
print(frame.f_back is None)
next(generator, None)
print(frame.f_back is None)
