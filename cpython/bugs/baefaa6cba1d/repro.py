import resource
print(resource.RLIM_INFINITY)
print(resource.RLIM_INFINITY == 2**64 - 1)
try:
    resource.setrlimit(resource.RLIMIT_FSIZE, (-5, resource.RLIM_INFINITY))
except Exception as e:
    print(type(e).__name__, e)
