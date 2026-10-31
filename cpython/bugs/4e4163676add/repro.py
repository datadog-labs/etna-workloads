import _pylong
from unittest import mock

k = 10_000
a, b = 1 << (2 * k), 1 << k
with mock.patch.object(_pylong, "int_divmod", wraps=lambda a, b: (1,)):
    try:
        print(divmod(a, b))
    except ValueError as e:
        print("ValueError:", e)
