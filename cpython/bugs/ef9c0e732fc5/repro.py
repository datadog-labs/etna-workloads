import xml.sax
from xml.sax import SAXException
from xml.sax.handler import ContentHandler
from unittest import mock

# Declares utf-8 but contains an invalid byte sequence -> parse error.
with open('bad.xml', 'wb') as f:
    f.write(b'<?xml version="1.0" encoding="utf-8"?><a>\xe9</a>')

builtin_open = open
opened = []

def mock_open(*args):
    f = builtin_open(*args)
    opened.append(f)
    return f

with mock.patch('xml.sax.saxutils.open', side_effect=mock_open):
    try:
        xml.sax.parse('bad.xml', ContentHandler())
    except SAXException as e:
        print('SAXException')
print('closed:', opened[0].closed)
