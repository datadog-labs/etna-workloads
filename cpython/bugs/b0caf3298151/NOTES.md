Calls `locale._parse_localename('UTF-8')`. Clean returns `(None, 'UTF-8')`; the buggy
build lacks the `code == 'UTF-8'` branch and raises `ValueError: unknown locale: UTF-8`.
