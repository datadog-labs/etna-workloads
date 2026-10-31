import _tkinter
from tkinter import Tcl
interp = Tcl()

class Value:
    def __str__(self):
        values.clear()
        return "value"

values = [Value(), "pad"]
print(repr(interp.call('set', '_', values)))
