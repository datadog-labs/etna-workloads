Reproducer: sets a Tcl variable to a string with an embedded NUL ('€\0') via
tkinter.Tcl().setvar, then reads it back with eval('set a').
Clean: '€\x00'. Buggy: '€' (string truncated at the NUL).
