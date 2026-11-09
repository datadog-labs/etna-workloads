Input: exported class expressions with `#private` fields/methods, compiled with `--declaration` (target es2015).
Clean: reports TS4094 (property of exported anonymous class type may not be private/protected) and exits non-zero.
Injected: no error for the `#private` members, so the exit status and output differ.
