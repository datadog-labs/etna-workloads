import xml.parsers.expat as expat

# A deeply nested content model in a DTD element declaration makes
# conv_content_model() recurse once per nesting level while building the
# Python tuple representation of the model.  With the recursion guard
# removed, this recursion is unbounded C recursion and overflows the C
# stack instead of raising RecursionError.
N = 500_000
data = (
    b"<!DOCTYPE root [\n<!ELEMENT root "
    + b"(a, " * N + b"a" + b")" * N
    + b">\n]>\n<root/>\n"
)

parser = expat.ParserCreate()
parser.ElementDeclHandler = lambda name, model: None

try:
    parser.Parse(data)
except RecursionError:
    print("RecursionError")
except expat.ExpatError as e:
    print("ExpatError:", e)
else:
    print("no exception")
