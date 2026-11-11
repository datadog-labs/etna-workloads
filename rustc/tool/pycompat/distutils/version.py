"""See __init__.py: import-only shim; using it is an error."""


class _Unavailable:
    def __init__(self, *a, **k):
        raise RuntimeError("etna distutils shim: distutils.version is not available (needs old Python)")


LooseVersion = StrictVersion = Version = _Unavailable
