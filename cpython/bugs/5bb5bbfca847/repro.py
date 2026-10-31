import tkinter
tcl = tkinter.Tcl().tk
for v in ['{sp\nam}', '"{spam}"', '{"spam"}', 'sp\\am', '"sp\\am"']:
    for arg in ([v], [[v]], [[v, 0]]):
        s = tkinter._join(arg)
        try:
            r = repr(tcl.call('lindex', s, 0))
        except Exception as e:
            r = 'ERR %s' % e
        print(repr(s), r)
