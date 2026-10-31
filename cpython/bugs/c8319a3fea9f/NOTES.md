Reproducer: create_autospec(dataclass, instance=True) and check isinstance(m, D) / m.__class__.
Clean: True / D class. Buggy: spec is a list of field names, so __class__ is not D (isinstance False).
