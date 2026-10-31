import contextlib, pprint
with contextlib.redirect_stdout(None):
    pprint.pprint('this should not fail')
print('ok')
