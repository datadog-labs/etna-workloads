import atexit

class Evil:
    def __eq__(self, other):
        atexit._clear()
        return NotImplemented

atexit.register(lambda: None)
atexit.unregister(Evil())
print("done")
