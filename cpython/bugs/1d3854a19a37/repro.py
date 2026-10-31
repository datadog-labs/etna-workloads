import io
wrapper = None
detached = False
class ReentrantRawIO(io.RawIOBase):
    @property
    def closed(self):
        global detached
        if wrapper is not None and not detached:
            detached = True
            wrapper.detach()
        return False

wrapper = io.TextIOWrapper(ReentrantRawIO())
wrapper.close()
print("ok")
