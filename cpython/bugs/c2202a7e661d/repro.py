import multiprocessing

def f():
    pass

if __name__ == '__main__':
    ctx = multiprocessing.get_context('spawn')
    p = ctx.Process(target=f)
    p.start()
    p.join()
    print(repr(multiprocessing.get_start_method(allow_none=True)))
