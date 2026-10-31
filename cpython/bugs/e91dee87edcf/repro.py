from email import _encoded_words as ew
print(repr(ew.decode('=?utf-8\udce2\udc80\udc9d?q?foo=ACbar?=')))
