import zoneinfo

class BombDescriptor:
    def __get__(self, obj, owner):
        return {}

class EvilZoneInfo(zoneinfo.ZoneInfo):
    pass

# Must be set after class creation.
EvilZoneInfo._weak_cache = BombDescriptor()

key = "America/Los_Angeles"
zone1 = EvilZoneInfo(key)
print(str(zone1))
EvilZoneInfo.clear_cache()
zone2 = EvilZoneInfo(key)
print(str(zone2), zone2 is zone1)
