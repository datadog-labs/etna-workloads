import array

# Translated from test.test_array.LargeArrayTest.test_setitem_use_after_clear_with_int_data
# (added by the upstream fix for gh-142555).
#
# array.__setitem__ converts the index to an integer by calling __index__()
# *before* checking that the index is within bounds. If __index__() clears
# the array (freeing and NULLing its ob_item buffer) as a side effect, the
# stale bounds check is skipped on the buggy interpreter and the write goes
# through a NULL/freed buffer, crashing the interpreter. The fixed
# interpreter re-validates the index against the (now empty) array after the
# conversion and raises IndexError instead.

victim = array.array('b', list(range(64)))


class Index:
    def __index__(self):
        victim.clear()
        return 0


try:
    victim[1] = Index()
except IndexError as e:
    print('IndexError:', e)
except BaseException as e:
    print('other exception:', type(e).__name__, e)
else:
    print('no exception')

print(repr(victim))
