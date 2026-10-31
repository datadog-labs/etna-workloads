import signal
from multiprocessing.resource_tracker import ResourceTracker

signal.pthread_sigmask(signal.SIG_SETMASK, {signal.SIGTERM})
tracker = ResourceTracker()
tracker.ensure_running()
print(sorted(s.name for s in signal.pthread_sigmask(signal.SIG_BLOCK, set())))
tracker._stop()
