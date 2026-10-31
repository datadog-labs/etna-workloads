class WeirdDict(dict):
    pass

ns = {}
exec('def foo(): return a', WeirdDict(), ns)
try:
    ns['foo']()
except NameError as e:
    print('NameError', e)
