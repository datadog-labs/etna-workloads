import warnings
with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    eval(r"f'\{{'")
print(len(w))
for x in w:
    print(x.category.__name__, x.message)
