import gc
import xml.parsers.expat as expat

parent = expat.ParserCreate()
sub = parent.ExternalEntityParserCreate(None)
del parent
gc.collect()

try:
    sub.Parse(b"<a/>", True)
except expat.ExpatError as e:
    print(repr(e))
else:
    print("no error")
