import multiprocessing

def put_one(q):
    q.put(1)

def put_two_and_nest(q):
    q.put(2)
    p = multiprocessing.Process(target=put_one, args=(q,))
    p.start()
    p.join()
    print("nested exitcode", p.exitcode)

if __name__ == "__main__":
    multiprocessing.set_start_method("spawn")
    q = multiprocessing.Queue()
    p = multiprocessing.Process(target=put_two_and_nest, args=(q,))
    p.start()
    p.join()
    print("outer exitcode", p.exitcode)
    print(sorted(q.get(timeout=5) for _ in range(2)))
