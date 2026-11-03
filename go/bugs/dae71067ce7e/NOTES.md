repro.go builds a local `[...][]*int{{&x}, nil, nil, nil, nil}` (issue 61730), then grows the stack and runs GC.
Clean: prints 1 2 3 11, exit 0.
Buggy: the array is laid out with the wrong init context, so a stack pointer (&x) is stored in a global static object.
The runtime then crashes (fatal error / stack dump, exit 2) when the GC finds the stale stack pointer.
The buggy output includes addresses, but the clean output is deterministic.
