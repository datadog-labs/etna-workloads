Reproducer prints wintypes.BYTE(-1).value: 255 on clean (BYTE is c_ubyte), -1 on buggy (c_byte), so BYTE is wrongly signed.
