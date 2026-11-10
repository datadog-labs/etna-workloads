Input: a module exporting `const a = class { private x = 1; }` compiled with `tsc --noEmit --declaration --strict`.
This yields a declaration-emit error (TS4094) that only shows up when declaration diagnostics are reported under --noEmit.
Clean build reports the TS4094 error (exit 2); injected build skips declaration diagnostics with --noEmit and prints nothing (exit 0).
