import os, warnings, zoneinfo
os.environ["PYTHONTZPATH"] = "foo"
with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    zoneinfo.reset_tzpath()
for x in w:
    print(x.category.__name__, os.path.basename(x.filename))
