repro.sh writes the issue43099 test program and compiles it with `go tool compile -p p`.
The program divides/mods by a value that only becomes constant 0 late in optimization.
Clean toolchain: compiles fine (exit 0). Buggy toolchain: internal compiler error
"panic during middle opt ... runtime error: integer divide by zero" (exit 2), because
the generic constant-folding rules for Div/Mod lost their `d != 0` guard.
