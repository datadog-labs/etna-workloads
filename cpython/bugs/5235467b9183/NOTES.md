Runs `python -m inspect --details sys` (builtin module) via runpy.
Clean: prints Target/Origin/Source/Cached/Loader details for the builtin module.
Buggy: prints "Can't get info for builtin modules." to stderr and exits with status 1.
