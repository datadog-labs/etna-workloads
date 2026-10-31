import zoneinfo

class ZI(zoneinfo.ZoneInfo):
    pass
delattr(ZI, '_weak_cache')

for f in (lambda: ZI("UTC"), lambda: ZI.clear_cache()):
    try:
        f()
    except AttributeError as e:
        print("AttributeError")
