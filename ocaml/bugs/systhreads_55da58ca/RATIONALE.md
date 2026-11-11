# Rationale
File: ocaml/otherlibs/systhreads/thread.ml (function `create`)
Removed the `| Exit -> ...` case from the thread body handler and the `| Exit -> ()` case from the
uncaught-exception-handler handler. This reverses the fix.diff hunk
`@@ -42,18 +41,25 @@ let uncaught_exception_handler = ...` (the part that makes Thread.Exit silently terminate a thread).
Thread.Exit is now treated as an ordinary uncaught exception (printed / passed to handler).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: bufchan, torture, uncaught_exception_handler fail; others pass.
