import builtins, codecs, warnings
warnings.simplefilter("ignore")

opened = []
real_open = builtins.open
def spy(*a, **k):
    f = real_open(*a, **k)
    opened.append(f)
    return f

builtins.open = spy
try:
    codecs.open("repro_tmp.txt", "w", "invalid-encoding")
except LookupError as e:
    print("LookupError", e)
finally:
    builtins.open = real_open
print("file closed:", opened[0].closed)
