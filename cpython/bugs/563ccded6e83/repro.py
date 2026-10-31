import shutil
for kw in ({}, {'ignore_errors': True}):
    try:
        shutil.rmtree('x', dir_fd='invalid', **kw)
    except BaseException as e:
        print(type(e).__name__)
    else:
        print('no exception')
