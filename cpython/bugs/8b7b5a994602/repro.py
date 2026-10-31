import unicodedata
for c in ['\U00017000','\U000187ff','\U00018d00','\U00018d1e','\U00013460','\U00018b00','\U0001b170']:
    n = unicodedata.name(c, None)
    print(hex(ord(c)), n)
    try:
        print(repr(unicodedata.lookup(n)) if n else None)
    except Exception as e:
        print(type(e).__name__, e)
for s in ["TANGUT IDEOGRAPH-17000","TANGUT IDEOGRAPH-18D1E","tangut ideograph-18d1e"]:
    try: print(ascii(unicodedata.lookup(s)))
    except Exception as e: print(type(e).__name__, e)
