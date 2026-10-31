import time
for d in ({"error": 0}, {"tm_year": 0}, {"tm_zone": "z"}):
    for s in ("123456789", "1234567890"):
        try:
            print(repr(time.struct_time(s, d).tm_zone))
        except TypeError as e:
            print("TypeError:", e)
