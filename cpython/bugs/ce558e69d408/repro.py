import _thread

def f():
    print("shouldn't be printed")

class AtFinalization:
    def __del__(self):
        print("OK")
        try:
            _thread.start_new_thread(f, ())
        except BaseException as e:
            print(type(e).__name__, e)

at_finalization = AtFinalization()
