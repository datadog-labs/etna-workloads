import sys

big = "".ljust(0x23000, "b")
name = "a." + big + ".c"

sys.modules[name] = {}
try:
    __import__(big + ".c", {"__package__": "a"}, level=1)
except KeyError as e:
    msg = str(e)
    print(msg.startswith("\"'a."), msg.endswith("' not in sys.modules as expected\""), len(msg))
else:
    print("no exception")
