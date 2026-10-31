import gc

TAG = object()
tuples = []

def referrer_tuples():
    return [x for x in gc.get_referrers(TAG) if isinstance(x, tuple)]

def my_iter():
    global tuples
    yield TAG
    tuples += referrer_tuples()
    for x in range(10):
        tuples += referrer_tuples()
        yield x

result = tuple(my_iter())
print(result == (TAG, *range(10)))
print(len(tuples))
