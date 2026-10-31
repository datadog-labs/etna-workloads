repro.py makes os.close raise OSError (after really closing the fd) while shutil.rmtree runs on a nested dir with an onexc handler, then prints the (function, path) pairs the handler received.

Clean: the handler is told the failing function is `close` for dir1/dir2 and dir1.
Buggy: it is reported as `rmdir` instead (the injection reassigns `func` before os.close). The buggy build also drops the try/except around the final close in the stack-unwinding path, so a close failure there is not routed to onexc.
