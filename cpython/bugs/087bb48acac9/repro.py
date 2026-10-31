import _interpreters
id = _interpreters.create()
try:
    _interpreters.exec(id, 'a', shared={"\uD82A": 0})
except UnicodeEncodeError as e:
    print(repr(e))
