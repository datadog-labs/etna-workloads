import zoneinfo

class Cache:
    def get(self, key, default=None):
        return 1337

class ZI(zoneinfo.ZoneInfo):
    pass
ZI._weak_cache = Cache()

try:
    print(repr(ZI("America/Los_Angeles")))
except RuntimeError as e:
    print("RuntimeError:", e)
