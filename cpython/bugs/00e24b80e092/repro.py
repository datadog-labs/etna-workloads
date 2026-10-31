import array


class E(array.array):
    def __hash__(self):
        mv.release()
        self.clear()
        return 123


v = E('B', b'A' * 4096)
mv = memoryview(v).toreadonly()  # must be read-only for hash()

for call in (lambda: hash(mv), lambda: mv.__hash__()):
    try:
        r = call()
        print('OK', r)
    except BufferError as exc:
        print('BufferError:', exc)
    except Exception as exc:
        print('%s: %s' % (type(exc).__name__, exc))
