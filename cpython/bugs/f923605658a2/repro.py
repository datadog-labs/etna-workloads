import gc, _datetime
c = _datetime.datetime_CAPI
print(gc.is_tracked(c))
print(len(gc.get_referents(c)))
