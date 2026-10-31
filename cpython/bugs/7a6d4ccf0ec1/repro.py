import linecache

for name in ['\x00', '𝄞.py']:
    try:
        print(repr(linecache.updatecache(name)))
    except Exception as e:
        print(type(e).__name__)
