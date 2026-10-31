from multiprocessing import shared_memory
from multiprocessing import resource_tracker

resource_tracker._resource_tracker._use_simple_format = True
for name in ["a:b", "a:b:c", "name\nwithnewline"]:
    shm = shared_memory.SharedMemory(create=True, size=100, name=name)
    shm.close()
    shm.unlink()
print("done")
