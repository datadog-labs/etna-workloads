import warnings

def outer():
    warnings.warn("msg", skip_file_prefixes=(__file__,))

with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    outer()
print(len(w))
for x in w:
    print(x.filename == __file__, x.lineno)
