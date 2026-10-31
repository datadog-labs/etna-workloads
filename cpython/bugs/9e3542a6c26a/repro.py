from sysconfig.__main__ import _parse_makefile
with open("Makefile", "w") as f:
    print("var1=$(CFLAGS)", file=f)
    print("PY_CFLAGS=-Wall $(CPPFLAGS)", file=f)
    print("PY_LDFLAGS=-lm", file=f)
    print("var2=$(LDFLAGS)", file=f)
    print("var3=$(CPPFLAGS)", file=f)
    print("var4=$$(var3)", file=f)
    print("var5=$(var6)(var3)", file=f)
    print("var6=$$", file=f)
try:
    print(sorted(_parse_makefile("Makefile").items()))
except BaseException as e:
    print(type(e).__name__, e)
