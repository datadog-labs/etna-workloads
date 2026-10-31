Reproducer: compares `socket.getfqdn()` with `socket.getfqdn("::")`.
Clean: `True` (`"::"` is treated like an empty name and replaced by `gethostname()`).
Buggy: `False` (`"::"` is no longer filtered, so it goes through `gethostbyaddr("::")`).
