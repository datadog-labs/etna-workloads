import multiprocessing as mp
import warnings
from concurrent import futures

warnings.simplefilter("ignore")

def fork_and_get_exitcode():
    p = mp.get_context('fork').Process(target=lambda: 1)
    p.start()
    p.join()
    return p.exitcode

with futures.ThreadPoolExecutor(1) as pool:
    print(pool.submit(fork_and_get_exitcode).result())
