Creates a program (in-memory host with `getGlobalTypingsCacheLocation` = `/home/cache/typescript`) whose root file lives inside the global typings cache and imports an unresolvable module, with `traceResolution` on.
Clean: the node_modules ancestor walk stops at the global cache directory.
Injected: the walk continues past it, so the trace also lists lookups in `/home/cache/node_modules`, `/home/node_modules` and `/node_modules`.
