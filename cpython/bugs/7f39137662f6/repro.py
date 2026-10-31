import gzip, io, gc, sys, warnings
warnings.simplefilter("ignore")
def hook(u):
    print("unraisable:", u.exc_type.__name__, u.exc_value)
sys.unraisablehook = hook
gzip.GzipFile(fileobj=io.BytesIO(), mode="w")
gc.collect()
print("done")
