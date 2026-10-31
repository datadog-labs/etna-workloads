try:
    print(repr((1).__round__(None)))
except Exception as e:
    print(type(e).__name__, e)
