Reproducer prints resource.RLIM_INFINITY and tries setrlimit with a negative soft limit.
Clean: RLIM_INFINITY is 2**64-1 and the negative limit raises ValueError.
Buggy: rlim2py/py2rlim use long long, so RLIM_INFINITY is -1 and negative limits are silently accepted (no exception).
