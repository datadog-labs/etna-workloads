repro.py copies/deepcopies codecs.lookup('base64') (a CodecInfo). Clean: copy works and preserves fields. Buggy: TypeError, CodecInfo.__new__() missing 'decode' (__getnewargs__ missing).
