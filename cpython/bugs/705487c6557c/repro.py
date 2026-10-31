NO_MORE = 2

def spam():
    if spam.is_recursive_call:
        return NO_MORE
    spam.is_recursive_call = True
    list(spam.iterator)
    return 1

spam.is_recursive_call = False
spam.iterator = iter(spam, NO_MORE)
try:
    print(repr(next(spam.iterator)))
except BaseException as e:
    print(type(e).__name__, e)
