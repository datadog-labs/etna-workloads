import tkinter
tcl = tkinter.Tcl()
tcl.call('set', 'a', 'a\0b')
print(repr(tcl.getvar('a')))
print(repr(tcl.call('set', 'a')))
tcl.setvar('a', '€\0')
print(repr(tcl.getvar('a')))
print(repr(tcl.eval('set a')))
