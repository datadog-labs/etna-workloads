import sys
sys.modules['_datetime'] = None
import datetime
import zoneinfo
print(zoneinfo.ZoneInfo.__module__)
