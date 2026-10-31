Reproducer for GH-117750: calls `self.__dict__.clear()` in `__init__`, then sets an attribute.
Clean: prints `{}` then `{'foo': None}`, exit 0.
Buggy: the dict is detached from the inline values on clear, so the later attribute store hits an assertion in `store_instance_attr_lock_held` (SIGABRT, exit -6).
