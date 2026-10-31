import io
from unittest import mock
from xml.dom import getDOMImplementation

SAMPLE = b'<?xml version="1.0"?>\n<html><title>x</title></html>'
with mock.patch("urllib.request.urlopen") as mock_open:
    mock_open.return_value = io.BytesIO(SAMPLE)
    imp = getDOMImplementation()
    source = imp.createDOMInputSource()
    builder = imp.createDOMBuilder(imp.MODE_SYNCHRONOUS, None)
    source.systemId = "http://example.com/2000/svg"
    try:
        doc = builder.parse(source)
        print(repr(doc.documentElement.tagName))
    except Exception as e:
        print(type(e).__name__, e)
