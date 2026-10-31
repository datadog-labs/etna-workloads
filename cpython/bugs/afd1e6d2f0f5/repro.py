import gettext, io, struct

hdr = (b"Project-Id-Version: x\n"
       b"#-#-#-#-#  messages.po (Studio)  #-#-#-#-#\n"
       b"Plural-Forms: nplurals=2; plural=(n != 1);\n")
# minimal MO with one entry: msgid "" -> header
mo = struct.pack("<IIIIIII", 0x950412de, 0, 1, 28, 36, 0, 0)
mo += struct.pack("<II", 0, 0) + struct.pack("<II", len(hdr), 44) + hdr + b"\0"
t = gettext.GNUTranslations(io.BytesIO(mo))
print(repr(t.info()))
