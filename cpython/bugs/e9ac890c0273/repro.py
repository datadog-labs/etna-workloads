import re
bad = []
for i in range(256):
    try:
        re.compile(r'()(?(1)\x%02x?)' % i)
    except Exception as e:
        bad.append((i, type(e).__name__, str(e)))
print(bad)
