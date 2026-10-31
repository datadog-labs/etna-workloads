import multiprocessing
ctx = multiprocessing.get_context('forkserver')
try:
    ctx.set_forkserver_preload([1, 2, 3])
except TypeError as e:
    print('TypeError', e)
else:
    print('no error')
