import unicodedata
for s in ('ᄀᅶᆨ', '기ᆧ', '기ᇃ'):
    print(ascii(unicodedata.normalize('NFC', s)))
