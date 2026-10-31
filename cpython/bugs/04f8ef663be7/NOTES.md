Runs the basic REPL (stdin piped, executable named `<stdin>`) with a PYTHONSTARTUP file defining `foo()` that does `1/0`, then feeds `foo()`.
Clean: the `<stdin>` frame shows `foo()`. Buggy: the interactive filename becomes `<stdin>-0` instead of `<stdin-0>`, so the traceback shows the wrong source line (`def foo():` from the startup file).
The banner is stripped because it contains build dates.
