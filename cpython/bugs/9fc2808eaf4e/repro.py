import _interpreters
i = _interpreters.create()
try:
    _interpreters.exec(i, 'a', shared=1)
except TypeError as e:
    print('TypeError', e)
