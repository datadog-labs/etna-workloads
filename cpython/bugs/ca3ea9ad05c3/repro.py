import resource
import _thread

def f():
    print("shouldn't be printed")

_, hard = resource.getrlimit(resource.RLIMIT_NPROC)
resource.setrlimit(resource.RLIMIT_NPROC, (0, hard))

try:
    _thread.start_joinable_thread(f)
except RuntimeError:
    print('ok')
else:
    print('skip')
