import multiprocessing
import sys


def fun():
    print(f"worker:{len(sys.argv)}:{sys.argv[-1]}")


if __name__ == "__main__":
    sys.argv[1:] = ["x" * 50] * 5000 + ["sentinel"]
    ctx = multiprocessing.get_context("forkserver")
    ctx.set_forkserver_preload(["__main__"])
    p = ctx.Process(target=fun)
    try:
        p.start()
        p.join()
        print("exitcode", p.exitcode)
    except BrokenPipeError as e:
        print("BrokenPipeError")
