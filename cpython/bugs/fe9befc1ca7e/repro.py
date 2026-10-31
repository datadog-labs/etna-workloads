import io, struct
import zoneinfo
from datetime import datetime

# Minimal TZif v1 file: 2 types, 2 transitions, second transition index (2) is out of range.
abbr = b"STD\0DST\0"
data = b"TZif" + b"\0" + b"\0" * 15
data += struct.pack(">6l", 0, 0, 0, 2, 2, len(abbr))
data += struct.pack(">2l", 1000000000, 1100000000)
data += bytes([0, 2])
data += struct.pack(">lbb", 0, 0, 0) + struct.pack(">lbb", 3600, 1, 4)
data += abbr

try:
    zi = zoneinfo.ZoneInfo.from_file(io.BytesIO(data))
    print("loaded")
    print(repr(datetime(2010, 1, 1, tzinfo=zi).utcoffset()))
except Exception as e:
    print(type(e).__name__, e)
