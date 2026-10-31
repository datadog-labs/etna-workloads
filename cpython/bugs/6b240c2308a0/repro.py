import functools
print(repr(type.__type_params__))
def wrapper(*args): pass
functools.update_wrapper(wrapper, type)
print(repr(wrapper.__type_params__))
