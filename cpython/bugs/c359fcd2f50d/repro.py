import unicodedata

class MyStr(str):
    pass

for form in ("NFC", "NFKC", "NFD", "NFKD"):
    for s in ("", "ascii"):
        print(form, repr(s), type(unicodedata.normalize(form, MyStr(s))).__name__)
