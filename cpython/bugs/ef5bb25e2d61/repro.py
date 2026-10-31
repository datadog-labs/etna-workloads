from email.header import Header
try:
    print(repr(Header(' ').encode()))
except Exception as e:
    print(type(e).__name__, e)
