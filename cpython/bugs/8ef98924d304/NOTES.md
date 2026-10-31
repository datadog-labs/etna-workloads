Reproducer: creates a weakref.ref and weakref.proxy to an object, prints both reprs (addresses scrubbed), drops the object, and prints the reprs again.
Clean: prints `<weakproxy at ...; dead>` for the dead proxy. Buggy: proxy_repr() dereferences a NULL referent and the interpreter segfaults (exit -11).
