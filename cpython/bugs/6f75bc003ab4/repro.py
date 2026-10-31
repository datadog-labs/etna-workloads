import multiprocessing as mp

def child(q):
    print(repr(q.empty()))

if __name__ == '__main__':
    ctx = mp.get_context('spawn')
    q = ctx.SimpleQueue()
    p = ctx.Process(target=child, args=(q,))
    p.start()
    p.join()
    print(p.exitcode)
