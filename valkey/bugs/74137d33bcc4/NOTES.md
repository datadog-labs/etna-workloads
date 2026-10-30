repro.sh starts a server, does INCR on a 100000-byte key (int-encoded value), and checks MEMORY USAGE is >= the key length.
Clean: "usage ok". Buggy: "usage too small", because objectComputeSize uses sizeof(*o) instead of zmalloc_size(o), so the key (embedded in the object) isn't counted.
