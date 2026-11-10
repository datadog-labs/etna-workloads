a.js contains `!< {:>`: a JSX opening tag with an empty tag name, parsed under a unary operator.
Clean: reports TS17008 diagnostics and exits 2.
Injected: parser crashes with "Debug Failure. Expected -1 >= 0" (error start > end, since Math.min was removed).
