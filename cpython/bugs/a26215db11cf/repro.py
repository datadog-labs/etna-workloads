from tkinter import Tcl
tcl = Tcl()
print(ascii(tcl.eval('set a "<\\ud83d\\udcbb>"')))
