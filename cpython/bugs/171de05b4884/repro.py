import sys, os, gc, wave
sys.unraisablehook = lambda u: print("unraisable:", u.exc_type.__name__, u.exc_value)
try:
    wave.open(os.curdir, "wb")
except OSError as e:
    print("OSError", type(e).__name__)
gc.collect()
print("done")
