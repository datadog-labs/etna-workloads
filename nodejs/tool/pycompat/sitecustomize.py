# Build-time compatibility for old Node.js revisions under Python 3.12 (anchors only):
# vendored jinja2/markupsafe in old V8 import ABCs from `collections` (removed in 3.10).
import collections
import collections.abc
for _n in ("Mapping", "MutableMapping", "Sequence", "MutableSequence", "Iterable", "Iterator",
           "Callable", "Set", "MutableSet", "Hashable", "Sized", "Container"):
    if not hasattr(collections, _n):
        setattr(collections, _n, getattr(collections.abc, _n))
