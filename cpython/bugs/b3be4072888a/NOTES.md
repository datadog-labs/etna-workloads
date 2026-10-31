Reproducer: calls StreamRecoder.writelines([b'a', b'b']) with an ascii codec and prints the BytesIO contents.
Clean: prints b'ab'. Buggy: codecs.py uses ''.join instead of b''.join, so it raises TypeError (sequence item 0: expected str instance, bytes found).
