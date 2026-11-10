Input is a simple async generator compiled with --target es2017, which needs the __asyncGenerator helper.
Clean emits the helper with `awaitReturn` and `verb("return", awaitReturn)`, so return() awaits its value.
Injected emits the older helper with `verb("return")` and no awaitReturn.
