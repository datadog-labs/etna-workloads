Input is a plain script file (`var x = 1;`, no import/export) compiled with `--isolatedModules --module amd`.
Clean: the file is not treated as a module, so the AMD output has no `define(...)` wrapper (and `--outFile` of non-modules works).
Injected: `isolatedModules` makes every file an effective external module, so the output is wrapped in `define([...])`/differs and diagnostics differ.
