Input: an exported interface with an index signature whose parameter type is an unresolved name (`TypeNotFound`); compiled with `tsc --declaration`.
Clean: reports only TS1268 and TS2304, and exits with the same code as without declaration emit.
Injected: also reports the spurious declaration-emit error TS4092 ("has or is using private name 'TypeNotFound'"), so the output and exit code differ.
