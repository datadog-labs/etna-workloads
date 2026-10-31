Calls `_ctypes.dlopen(b'missing\xff.so', 2)`. dlerror() text contains the raw 0xff byte.
Clean: OSError (message decoded with locale encoding). Buggy: UnicodeDecodeError, since
PyErr_SetString decodes the message as strict UTF-8.
